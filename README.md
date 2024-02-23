# Speech To Text Google

This package is implemented to display the Google speech to text dialog. There is no need to get any
permission from the user for this. This package is currently available on Android.

![DemoAndroid](https://raw.githubusercontent.com/miladhf/speech_to_text_google_dialog/master/example/screenshots/example_android.gif)

## Usage

### Example

This example shows how to display a google speech to text dialog and get the result.

```dart
bool isServiceAvailable = await SpeechToTextGoogle.getInstance()
                    .showGoogleDialog(onTextReceived: (data) {
                },
                  // locale: "en-US",
);
```
