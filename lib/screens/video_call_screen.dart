import 'package:agora_uikit/agora_uikit.dart';
import 'package:flutter/material.dart';

class VideoCallScreen extends StatefulWidget {
  const VideoCallScreen({super.key});

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final AgoraClient _client = AgoraClient(
    agoraConnectionData: AgoraConnectionData(
      appId: 'b964402a29a645cbb7eddae315f6753f',
      channelName: 'test',
      tempToken:
          '007eJxTYDjpMKVm5fqPbd4LFi8/YJqWte9Qxk+Xa/HK86a0/P23p/ugAkOSpZmJiYFRopFlopmJaXJSknlqSkpiqrGhaZqZualxWocpc2ZDICODjfFaZkYGCATxWRhKUotLGBgARlkh/w==',
    ),
  );

  @override
  void initState() {
    super.initState();
    _initAgora();
  }

  void _initAgora() async {
    await _client.initialize();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Video Call'),
      ),
      body: SafeArea(
        child: Stack(
          children: [
            AgoraVideoViewer(
              client: _client,
              layoutType: Layout.floating,
              enableHostControls: true, // Add this to enable host controls
            ),
            AgoraVideoButtons(
              client: _client,
              enabledButtons: const [
                BuiltinButtons.toggleCamera,
                BuiltinButtons.callEnd,
                BuiltinButtons.toggleMic,
                BuiltinButtons.switchCamera,
                BuiltinButtons.screenSharing
              ],
            ),
          ],
        ),
      ),
    );
  }
}
