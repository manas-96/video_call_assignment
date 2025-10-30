import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

class VideoCallController with ChangeNotifier {
  RtcEngine? _engine;
  bool _isJoined = false;
  int? _remoteUid;
  bool _localUserJoined = false;
  bool _isMuted = false;
  bool _isVideoDisabled = false;

  bool get isJoined => _isJoined;
  int? get remoteUid => _remoteUid;
  bool get localUserJoined => _localUserJoined;
  bool get isMuted => _isMuted;
  bool get isVideoDisabled => _isVideoDisabled;
  RtcEngine? get engine => _engine;

  final String _appId = 'b964402a29a645cbb7eddae315f6753f';
  final String _channelName = 'test';
  final String _token =
      '007eJxTYDjpMKVm5fqPbd4LFi8/YJqWte9Qxk+Xa/HK86a0/P23p/ugAkOSpZmJiYFRopFlopmJaXJSknlqSkpiqrGhaZqZualxWocpc2ZDICODjfFaZkYGCATxWRhKUotLGBgARlkh/w==';

  Future<void> initAgora() async {
    _engine = createAgoraRtcEngine();
    await _engine!.initialize(RtcEngineContext(appId: _appId));

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

  void toggleMute() {
    _isMuted = !_isMuted;
    _engine!.muteLocalAudioStream(_isMuted);
    notifyListeners();
  }

  void toggleVideo() {
    _isVideoDisabled = !_isVideoDisabled;
    _engine!.enableLocalVideo(!_isVideoDisabled);
    notifyListeners();
  }

  void switchCamera() {
    _engine!.switchCamera();
  }

  void screenShare() async {
    await _engine!.startScreenCapture(const ScreenCaptureParameters2(
        captureAudio: true,
        audioParams: ScreenAudioParameters(
            sampleRate: 16000, channels: 2, captureSignalVolume: 100),
        captureVideo: true,
        videoParams: ScreenVideoParameters(
            dimensions: VideoDimensions(height: 1920, width: 1080),
            frameRate: 15,
            bitrate: 6000)));
  }

  @override
  void dispose() {
    _engine?.leaveChannel();
    _engine?.release();
    super.dispose();
  }
}
