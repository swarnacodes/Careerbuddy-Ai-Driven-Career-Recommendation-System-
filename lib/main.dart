// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project_career/screens/welcome_screen.dart';
import 'firebase_options.dart'; // Import the firebase_options.dart file
import 'package:google_generative_ai/google_generative_ai.dart'; // Replace with the actual package name

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform, // Use the options from firebase_options.dart
  );
  runApp(MainApp());
}
class MainApp extends StatefulWidget {
  @override
  _MainAppState createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  late final GenerativeModel geminiVisionProModel;

  @override
  void initState() {
    super.initState();
    geminiVisionProModel = GenerativeModel(
      model: 'geminimodel',
      apiKey: 'apiKey', // Replace with your actual API key
      safetySettings: [
        SafetySetting(HarmCategory.harassment, HarmBlockThreshold.high),
        SafetySetting(HarmCategory.hateSpeech, HarmBlockThreshold.high),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gemini AI App',
      home: WelcomeScreen(),
    );
  }
}

