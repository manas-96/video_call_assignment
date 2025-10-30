import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:video_call_assignment/controllers/video_call_controller.dart';

class VideoCallView extends StatefulWidget {
  const VideoCallView({super.key});

  @override
  State<VideoCallView> createState() => _VideoCallViewState();
}

class _VideoCallViewState extends State<VideoCallView> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<VideoCallController>(context, listen: false).initAgora();
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = Provider.of<VideoCallController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Agora Video Call'),
        centerTitle: true,
      ),
      body: Stack(
        children: [
          Center(child: _remoteVideo(controller)),
          Positioned(
            top: 20,
            left: 20,
            child: SizedBox(
              width: 120,
              height: 160,
              child: _localVideo(controller),
            ),
          ),
          _toolbar(controller),
        ],
      ),
    );
  }

  Widget _remoteVideo(VideoCallController controller) {
    if (controller.remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: controller.engine!,
          canvas: VideoCanvas(uid: controller.remoteUid),
          connection:
          const RtcConnection(channelId: 'test_video'), // match your channel
        ),
      );
    } else {
      return const Text(
        'Waiting for remote user to join...',
        textAlign: TextAlign.center,
      );
    }
  }

  Widget _localVideo(VideoCallController controller) {
    if (controller.localUserJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: controller.engine!,
          canvas: const VideoCanvas(uid: 0),
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
  }

  Widget _toolbar(VideoCallController controller) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 40),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _circleButton(
              icon: controller.isMuted ? Icons.mic_off : Icons.mic,
              color: controller.isMuted ? Colors.blueAccent : Colors.white,
              iconColor:
              controller.isMuted ? Colors.white : Colors.blueAccent,
              onPressed: controller.toggleMute,
            ),
            _circleButton(
              icon: Icons.call_end,
              color: Colors.redAccent,
              iconColor: Colors.white,
              onPressed: () => Navigator.pop(context),
              padding: 20,
            ),
            _circleButton(
              icon:
              controller.isVideoDisabled ? Icons.videocam_off : Icons.videocam,
              color: controller.isVideoDisabled
                  ? Colors.blueAccent
                  : Colors.white,
              iconColor: controller.isVideoDisabled
                  ? Colors.white
                  : Colors.blueAccent,
              onPressed: controller.toggleVideo,
            ),
            _circleButton(
              icon: Icons.switch_camera,
              color: Colors.white,
              iconColor: Colors.blueAccent,
              onPressed: controller.switchCamera,
            ),
            _circleButton(
              icon: Icons.screen_share,
              color: Colors.white,
              iconColor: Colors.blueAccent,
              onPressed: controller.startScreenShare,
            ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({
    required IconData icon,
    required Color color,
    required Color iconColor,
    required VoidCallback onPressed,
    double padding = 14,
  }) {
    return RawMaterialButton(
      onPressed: onPressed,
      shape: const CircleBorder(),
      fillColor: color,
      padding: EdgeInsets.all(padding),
      child: Icon(icon, color: iconColor, size: 22),
    );
  }
}
