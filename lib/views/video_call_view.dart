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
    final videoCallController = Provider.of<VideoCallController>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
      ),
      body: Stack(
        children: [
          Center(
            child: _remoteVideo(videoCallController),
          ),
          Align(
            alignment: Alignment.topLeft,
            child: SizedBox(
              width: 100,
              height: 150,
              child: _localVideo(videoCallController),
            ),
          ),
          _toolbar(videoCallController),
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
          connection: const RtcConnection(channelId: 'test'),
        ),
      );
    } else {
      return const Text(
        'Waiting for remote user to join',
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
      return const CircularProgressIndicator();
    }
  }

  Widget _toolbar(VideoCallController controller) {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 48),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          RawMaterialButton(
            onPressed: controller.toggleMute,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: controller.isMuted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              controller.isMuted ? Icons.mic_off : Icons.mic,
              color: controller.isMuted ? Colors.white : Colors.blueAccent,
              size: 20.0,
            ),
          ),
          RawMaterialButton(
            onPressed: () => Navigator.pop(context),
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15.0),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35.0,
            ),
          ),
          RawMaterialButton(
            onPressed: controller.toggleVideo,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor:
                controller.isVideoDisabled ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: Icon(
              controller.isVideoDisabled ? Icons.videocam_off : Icons.videocam,
              color: controller.isVideoDisabled
                  ? Colors.white
                  : Colors.blueAccent,
              size: 20.0,
            ),
          ),
          RawMaterialButton(
            onPressed: controller.switchCamera,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: const Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20.0,
            ),
          ),
          RawMaterialButton(
            onPressed: controller.screenShare,
            shape: const CircleBorder(),
            elevation: 2.0,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12.0),
            child: const Icon(
              Icons.screen_share,
              color: Colors.blueAccent,
              size: 20.0,
            ),
          ),
        ],
      ),
    );
  }
}
