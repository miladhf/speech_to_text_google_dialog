library speech_to_text_google_dialog;

import 'dart:async';

import 'package:flutter/services.dart';

///Provides ability to show the Google speech to text dialog
class SpeechToTextGoogleDialog {
  static SpeechToTextGoogleDialog? _instance;
  final EventChannel _stream = const EventChannel('SpeechToTextGoogleStream');
  final _platform = const MethodChannel('SpeechToTextGoogleChannel');

  ///This function provide singleton object of [SpeechToTextGoogleDialog]
  static SpeechToTextGoogleDialog getInstance() {
    _instance ??= SpeechToTextGoogleDialog();
    return _instance!;
  }

  ///This function showing the Google speech to text dialog
  ///This function returns a boolean value that indicates service availability
  Future<bool> showGoogleDialog(
      {required Function(dynamic data) onTextReceived}) async {
    try {
      //call platform specific function
      final bool? result =
          await _platform.invokeMethod('showSpeechToTextDialog');
      //passing the received text to [onTextReceived] function
      _stream.receiveBroadcastStream().listen(onTextReceived);
      return result ?? false;
    } on PlatformException {
      return false;
    }
  }
}
