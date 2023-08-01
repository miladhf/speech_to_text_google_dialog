import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'speech_to_text_google_method_channel.dart';

abstract class SpeechToTextGooglePlatform extends PlatformInterface {
  /// Constructs a SpeechToTextGooglePlatform.
  SpeechToTextGooglePlatform() : super(token: _token);

  static final Object _token = Object();

  static SpeechToTextGooglePlatform _instance = MethodChannelSpeechToTextGoogle();

  /// The default instance of [SpeechToTextGooglePlatform] to use.
  ///
  /// Defaults to [MethodChannelSpeechToTextGoogle].
  static SpeechToTextGooglePlatform get instance => _instance;

  /// Platform-specific implementations should set this with their own
  /// platform-specific class that extends [SpeechToTextGooglePlatform] when
  /// they register themselves.
  static set instance(SpeechToTextGooglePlatform instance) {
    PlatformInterface.verifyToken(instance, _token);
    _instance = instance;
  }

  Future<String?> getPlatformVersion() {
    throw UnimplementedError('platformVersion() has not been implemented.');
  }
}
