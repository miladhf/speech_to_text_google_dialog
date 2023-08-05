library speech_to_text_google_dialog;

import 'dart:async';

import 'package:flutter/services.dart';

class SpeechToTextGoogleDialog {
  static SpeechToTextGoogleDialog? _instance;
  final EventChannel _stream = const EventChannel('SpeechToTextGoogleStream');
  final _platform = const MethodChannel('SpeechToTextGoogleChannel');
  StreamSubscription? _listener;

  static SpeechToTextGoogleDialog getInstance() {
    _instance ??= SpeechToTextGoogleDialog();
    return _instance!;
  }

  Future<bool> showGoogleDialog(
      {required Function(dynamic data) onTextReceived}) async {
    try {
      final bool? result =
          await _platform.invokeMethod('showSpeechToTextDialog');
      _listener ??= _stream.receiveBroadcastStream().listen(onTextReceived);
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }
}
