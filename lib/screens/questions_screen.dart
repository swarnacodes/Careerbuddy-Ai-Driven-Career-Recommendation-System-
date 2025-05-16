import 'package:flutter/material.dart';
import 'package:project_career/services/gemini_ai_service.dart';
import 'package:project_career/services/firebase_service.dart';
import 'results_screen.dart';

class QuestionsScreen extends StatefulWidget {
  @override
  _QuestionsScreenState createState() => _QuestionsScreenState();
}

class _QuestionsScreenState extends State<QuestionsScreen> {
  final FirebaseService _firebaseService = FirebaseService.instance;
  final GeminiApiService _geminiApiService = GeminiApiService();
  List<Map<String, dynamic>>? questions;
  final Map<int, List<String>> answers = {};
  int _currentQuestionIndex = 0;
  bool _isLoading = false;
  bool _isGenerating = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  Future<void> _loadQuestions() async {
    setState(() => _isLoading = true);
    try {
      questions = await _firebaseService.getQuestions();
      if (questions == null || questions!.isEmpty) {
        _showError('No questions found');
      }
    } catch (e) {
      _showError('Failed to load questions');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(title: const Text('CareerBuddy')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (questions == null || questions!.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('CareerBuddy')),
        body: const Center(child: Text('No questions available')),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('CareerBuddy',
          style: TextStyle(
            color: Colors.white,
            fontSize: 22, // Adjusted font size
            fontFamily: 'Roboto', // Specified font family
            fontWeight: FontWeight.w600, // Optional: Add font weight
          ),
        ),
        backgroundColor: Color(0xFF7986CB),
        elevation: 0,
        centerTitle: true,
      ),
      body: Container(
        color: Colors.white,
        child: Column(
          children: [
            _buildProgressHeader(screenWidth),
            Expanded(
              child: SingleChildScrollView(
                padding: EdgeInsets.symmetric(vertical: 0),
                child: Column(
                  children: [
                    _buildQuestionCard(context),
                    SizedBox(height: 24),
                    _buildOptionsContainer(context),
                  ],
                ),
              ),
            ),
            _buildNavigationButton(context),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressHeader(double screenWidth) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 0),
      decoration: BoxDecoration(
        color: Color(0xFF7986CB),

      boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.5),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Center(
        child: Text(
          'Question ${_currentQuestionIndex + 1} of ${questions!.length}',
          style: TextStyle(
            fontSize: screenWidth * 0.048,
            color: Colors.white,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context) {
    final currentQuestion = questions![_currentQuestionIndex];

    return Container(
      margin: EdgeInsets.only(top: 20), // Add top margin
      padding: EdgeInsets.symmetric(horizontal: 24),
      child: Text(
        currentQuestion['text'],
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w600,
          color: Colors.grey[800],
          height: 1.4,
        ),
        textAlign: TextAlign.center,
      ),
    );
  }

  Widget _buildOptionsContainer(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 8,
            offset: Offset(0, 4),
          ),
        ],
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: _buildOptionsGrid(context),
      ),
    );
  }

  Widget _buildOptionsGrid(BuildContext context) {
    final currentQuestion = questions![_currentQuestionIndex];
    final options = List<String>.from(currentQuestion['options']);

    return GridView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      padding: EdgeInsets.all(16),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2.5,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        mainAxisExtent: 80,
      ),
      itemCount: options.length,
      itemBuilder: (context, index) => _buildOptionChip(options[index]),
    );
  }

  Widget _buildOptionChip(String option) {
    final isSelected = answers[_currentQuestionIndex]?.contains(option) ?? false;

    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: () => _selectAnswer(option),
      child: Container(
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF7986CB) : Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? Color(0xFF7986CB) : Colors.grey[300]!,
            width: 1.5,
          ),
          boxShadow: [
            if (isSelected)
              BoxShadow(
                color: Colors.deepPurple.withOpacity(0.2),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
          ],
        ),
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Center(
          child: Text(
            option,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: isSelected ? Colors.white : Colors.grey[800],
            ),
            textAlign: TextAlign.center,
            softWrap: true,
          ),
        ),
      ),
    );
  }

  Widget _buildNavigationButton(BuildContext context) {
    return SafeArea(
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 16,
              offset: Offset(0, -4),
            ),
          ],
        ),
        child: ElevatedButton(
          onPressed: _isGenerating ? null : _nextQuestion,
          style: ElevatedButton.styleFrom(
            backgroundColor: Color(0xFF7986CB),
            minimumSize: Size(double.infinity, 56),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            elevation: 4,
            padding: EdgeInsets.symmetric(vertical: 16),
          ),
          child: _isGenerating
              ? SizedBox(
            height: 24,
            width: 24,
            child: CircularProgressIndicator(
              color: Colors.white,
              strokeWidth: 2,
            ),
          )
              : Text(
            _currentQuestionIndex < questions!.length - 1
                ? 'Next Question →'
                : 'Get Recommendations',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }

  void _selectAnswer(String option) {
    setState(() {
      answers[_currentQuestionIndex] ??= [];
      if (answers[_currentQuestionIndex]!.contains(option)) {
        answers[_currentQuestionIndex]!.remove(option);
      } else {
        answers[_currentQuestionIndex]!.add(option);
      }
    });
  }

  Future<void> _nextQuestion() async {
    if (_currentQuestionIndex < questions!.length - 1) {
      setState(() => _currentQuestionIndex++);
    } else {
      setState(() => _isGenerating = true);
      try {
        final prompt = _buildPrompt();
        final recommendations = await _geminiApiService.generateCareerRecommendations(prompt);

        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => ResultsScreen(
                userAnswers: answers.values.expand((x) => x).toList(),
                recommendations: recommendations,
              ),
            ),
          );
        }
      } catch (e) {
        _showError('Failed to generate recommendations: ${e.toString()}');
      } finally {
        if (mounted) setState(() => _isGenerating = false);
      }
    }
  }

  String _buildPrompt() {
    final buffer = StringBuffer(
        'Generate 5 career recommendations based on these answers:\n\n'
    );

    answers.forEach((index, options) {
      buffer.write('Question ${index + 1}: ${options.join(', ')}\n');
    });

    buffer.write(
        '\nProvide recommendations in this format:\n'
            '1. Career Title: Brief description\n'
            '2. Career Title: Brief description\n'
            '...'
    );

    return buffer.toString();
  }
}