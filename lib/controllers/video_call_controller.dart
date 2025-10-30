import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/foundation.dart';
import 'package:permission_handler/permission_handler.dart';

class VideoCallController with ChangeNotifier {
  RtcEngine? _engine;
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _isMuted = false;
  bool _isVideoDisabled = false;

  // Getters
  RtcEngine? get engine => _engine;
  int? get remoteUid => _remoteUid;
  bool get localUserJoined => _localUserJoined;
  bool get isMuted => _isMuted;
  bool get isVideoDisabled => _isVideoDisabled;

  // Replace these with your actual values
  final String _appId = 'b964402a29a645cbb7eddae315f6753f';
  final String _channelName = 'test_video';
  final String _token =
      '007eJxTYBDcNHeVdY+B9rJ/Z0U1TGdztIYsStZ/pLaOTWPne4sSyzMKDEmWZiYmBkaJRpaJZiamyUlJ5qkpKYmpxoamaWbmpsZpXTnMmQ2BjAxNDCbMjAwQCOJzMZSkFpfEl2WmpOYzMAAAYO0fMg==';

  /// Initialize Agora engine and join channel
  Future<void> initAgora() async {
    await [Permission.camera, Permission.microphone].request();

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(
      const RtcEngineContext(
        appId: 'b964402a29a645cbb7eddae315f6753f',
        channelProfile: ChannelProfileType.channelProfileCommunication,
      ),
    );

    _engine!.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (RtcConnection connection, int elapsed) {
          _localUserJoined = true;
          notifyListeners();
        },
        onUserJoined: (RtcConnection connection, int remoteUid, int elapsed) {
          _remoteUid = remoteUid;
          notifyListeners();
        },
        onUserOffline: (RtcConnection connection, int remoteUid,
            UserOfflineReasonType reason) {
          _remoteUid = null;
          notifyListeners();
        },
        onError: (err, msg) {
          if (kDebugMode) print("Agora Error: $err - $msg");
        },
      ),
    );

    await _engine!.enableVideo();
    await _engine!.startPreview();

    await _engine!.joinChannel(
      token: _token,
      channelId: _channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  /// Mute/unmute audio
  void toggleMute() {
    _isMuted = !_isMuted;
    _engine?.muteLocalAudioStream(_isMuted);
    notifyListeners();
  }

  /// Enable/disable local video
  void toggleVideo() {
    _isVideoDisabled = !_isVideoDisabled;
    _engine?.enableLocalVideo(!_isVideoDisabled);
    notifyListeners();
  }

  /// Switch camera
  void switchCamera() {
    _engine?.switchCamera();
  }

  /// Start screen sharing
  Future<void> startScreenShare() async {
    await _engine?.startScreenCapture(const ScreenCaptureParameters2(
      captureAudio: true,
      audioParams: ScreenAudioParameters(
        sampleRate: 16000,
        channels: 2,
        captureSignalVolume: 100,
      ),
      captureVideo: true,
      videoParams: ScreenVideoParameters(
        dimensions: VideoDimensions(width: 1280, height: 720),
        frameRate: 15,
        bitrate: 4000,
      ),
    ));
  }

  /// Cleanup
  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }
}
