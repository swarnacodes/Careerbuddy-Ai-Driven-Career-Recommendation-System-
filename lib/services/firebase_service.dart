import '../config.dart';
import 'package:firebase_core/firebase_core.dart';
// Add these imports for Firestore if you are using it
import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseService {
  static FirebaseService? _instance;
  FirebaseApp? _firebaseApp;
  FirebaseFirestore? _firestore; // Add Firestore instance

  FirebaseService._(); // Private constructor

  static FirebaseService get instance {
    _instance ??= FirebaseService._();
    return _instance!;
  }

  Future<void> initialize() async {
    try {
      final options = DefaultFirebaseOptions.getPlatformOptions();

      if (options != null) {
        _firebaseApp = await Firebase.initializeApp(options: options);
        _firestore = FirebaseFirestore.instance; // Initialize Firestore

        print('Firebase initialized successfully!');
      } else {
        print('Firebase initialization failed: Unsupported platform.');
      }
    } catch (e) {
      print('Error initializing Firebase: $e');
      // Handle error
    }
  }

  // Add the getQuestions method here:
  Future<List<Map<String, dynamic>>> getQuestions() async {
    try {
      CollectionReference questionsCollection =
      FirebaseFirestore.instance.collection('questions');

      QuerySnapshot snapshot = await questionsCollection.get();
      List<Map<String, dynamic>> questions = [];
      for (var doc in snapshot.docs) {
        questions.add(doc.data() as Map<String, dynamic>);
      }
      print("Questions from Firestore: $questions"); // Check data in console
      return questions;
    } catch (e) {
      print('Error getting questions: $e');
      return []; // Return empty list on error
    }
  }}