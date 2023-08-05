import 'package:flutter/material.dart';
import 'package:speech_to_text_google_dialog/speech_to_text_google_dialog.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Speech To Text Google',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SafeArea(child: Home()),
    );
  }
}

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  String? result;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: [
            Expanded(
                child: SingleChildScrollView(
                    padding: const EdgeInsets.all(25),
                    child: Text(
                      'result=${result ?? ''}',
                      textAlign: TextAlign.center,
                    ))),
            ElevatedButton(
              onPressed: () async {
                bool isServiceAvailable =
                    await SpeechToTextGoogleDialog.getInstance()
                        .showGoogleDialog(onTextReceived: (data) {
                  setState(() {
                    result = data.toString();
                  });
                });
                if (!isServiceAvailable) {
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: const Text('Service is not available'),
                    backgroundColor: Colors.red,
                    behavior: SnackBarBehavior.floating,
                    margin: EdgeInsets.only(
                      bottom: MediaQuery.of(context).size.height - 100,
                      left: 16,
                      right: 16,
                    ),
                  ));
                }
              },
              child: const Text('show dialog'),
            ),
            const SizedBox(
              height: 25,
            ),
          ],
        ),
      ),
    );
  }
}
