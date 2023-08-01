
import 'speech_to_text_google_platform_interface.dart';

class SpeechToTextGoogle {
  Future<String?> getPlatformVersion() {
    return SpeechToTextGooglePlatform.instance.getPlatformVersion();
  }
}
