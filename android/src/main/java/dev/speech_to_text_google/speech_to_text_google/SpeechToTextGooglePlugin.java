package dev.speech_to_text_google.speech_to_text_google;

import android.content.ActivityNotFoundException;
import android.content.Context;
import android.content.Intent;
import android.speech.RecognizerIntent;

import androidx.annotation.NonNull;
import androidx.annotation.Nullable;

import java.util.ArrayList;
import java.util.Locale;

import io.flutter.embedding.engine.plugins.FlutterPlugin;
import io.flutter.embedding.engine.plugins.activity.ActivityAware;
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding;
import io.flutter.plugin.common.BinaryMessenger;
import io.flutter.plugin.common.EventChannel;
import io.flutter.plugin.common.MethodChannel;
import io.flutter.plugin.common.PluginRegistry;

public class SpeechToTextGooglePlugin implements FlutterPlugin, ActivityAware, PluginRegistry.ActivityResultListener {

    private static final String CHANNEL = "SpeechToTextGoogleChannel";
    private static final String STREAM = "SpeechToTextGoogleStream";
    private static final int REQ_CODE_SPEECH_INPUT = 120752;
    private static EventChannel.EventSink eventSink;
    private MethodChannel methodChannel;
    private EventChannel eventChannel;
    private android.app.Activity activity;

    @Override
    public void onAttachedToEngine(FlutterPluginBinding binding) {
        setupChannels(binding.getBinaryMessenger(), binding.getApplicationContext());
    }

    @Override
    public void onDetachedFromEngine(@NonNull FlutterPluginBinding binding) {
        teardownChannels();
    }

    private void setupChannels(BinaryMessenger messenger, Context context) {
        methodChannel = new MethodChannel(messenger, CHANNEL);
        methodChannel.setMethodCallHandler(
                (call, result) -> {
                    if (call.method.equals("showSpeechToTextDialog")) {
                        String locale = call.argument("locale");

                        //Intent to listen to user vocal input and return result in same activity
                        Intent intent = new Intent(RecognizerIntent.ACTION_RECOGNIZE_SPEECH);

                        //Use a language model based on free-form speech recognition.
                        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE_MODEL,
                                RecognizerIntent.LANGUAGE_MODEL_FREE_FORM);
                        intent.putExtra(RecognizerIntent.EXTRA_LANGUAGE, locale != null ? locale : Locale.getDefault());

                        //Message to display in dialog box
                        intent.putExtra(RecognizerIntent.EXTRA_PROMPT,
                                "Record");
                        try {
                            activity.startActivityForResult(intent, REQ_CODE_SPEECH_INPUT);
                            result.success(true);
                        } catch (ActivityNotFoundException a) {
                            result.error("400", "error", false);

                        }

                    } else {
                        result.notImplemented();
                    }
                }
        );

        eventChannel = new EventChannel(messenger, STREAM);
        eventChannel.setStreamHandler(new EventChannel.StreamHandler() {
            @Override
            public void onListen(Object listener, EventChannel.EventSink eventSink) {
                SpeechToTextGooglePlugin.eventSink = eventSink;

            }

            @Override
            public void onCancel(Object listener) {
            }
        });
    }

    private void teardownChannels() {
        methodChannel.setMethodCallHandler(null);
        eventChannel.setStreamHandler(null);
        methodChannel = null;
        eventChannel = null;
    }

    @Override
    public void onAttachedToActivity(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        binding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivityForConfigChanges() {

        activity = null;
    }

    @Override
    public void onReattachedToActivityForConfigChanges(@NonNull ActivityPluginBinding binding) {
        activity = binding.getActivity();
        binding.addActivityResultListener(this);
    }

    @Override
    public void onDetachedFromActivity() {
        activity = null;
    }

    @Override
    public boolean onActivityResult(int requestCode, int resultCode, @Nullable Intent data) {
        if (requestCode == REQ_CODE_SPEECH_INPUT) {
            if (data != null) {

                ArrayList<String> result = data
                        .getStringArrayListExtra(RecognizerIntent.EXTRA_RESULTS);

                if (!result.isEmpty()) {
                    String text = result.get(0);
                    eventSink.success(text);
                }
            }
        }
        return true;
    }
}
