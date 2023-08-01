library speech_to_text_google;

import 'dart:async';

import 'package:flutter/services.dart';

class SpeechToTextGoogle {
  static SpeechToTextGoogle? _instance;
  final EventChannel _stream = const EventChannel('SpeechToTextGoogleStream');
  final _platform = const MethodChannel('SpeechToTextGoogleChannel');
  StreamSubscription? _listener;

  static SpeechToTextGoogle getInstance() {
    _instance ??= SpeechToTextGoogle();
    return _instance!;
  }

  Future<bool> showGoogleDialog(
      {required Function(dynamic data) onTextReceived}) async {
    try {
      final bool? result =
          await _platform.invokeMethod('showSpeechToTextDialog');
      _listener ??= _stream.receiveBroadcastStream().listen(onTextReceived);
      return result ?? false;
    } on PlatformException catch (e) {
      return false;
    }
  }
}
