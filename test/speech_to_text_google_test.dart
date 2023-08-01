import 'package:flutter_test/flutter_test.dart';
import 'package:speech_to_text_google/speech_to_text_google.dart';
import 'package:speech_to_text_google/speech_to_text_google_platform_interface.dart';
import 'package:speech_to_text_google/speech_to_text_google_method_channel.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

class MockSpeechToTextGooglePlatform
    with MockPlatformInterfaceMixin
    implements SpeechToTextGooglePlatform {

  @override
  Future<String?> getPlatformVersion() => Future.value('42');
}

void main() {
  final SpeechToTextGooglePlatform initialPlatform = SpeechToTextGooglePlatform.instance;

  test('$MethodChannelSpeechToTextGoogle is the default instance', () {
    expect(initialPlatform, isInstanceOf<MethodChannelSpeechToTextGoogle>());
  });

  test('getPlatformVersion', () async {
    SpeechToTextGoogle speechToTextGooglePlugin = SpeechToTextGoogle();
    MockSpeechToTextGooglePlatform fakePlatform = MockSpeechToTextGooglePlatform();
    SpeechToTextGooglePlatform.instance = fakePlatform;

    expect(await speechToTextGooglePlugin.getPlatformVersion(), '42');
  });
}
