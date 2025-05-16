import 'package:flutter/material.dart';
import 'chatbot_screen.dart';

class ResultsScreen extends StatelessWidget {
  final List<String> userAnswers;
  final List<String> recommendations;

  const ResultsScreen({
    super.key,
    required this.userAnswers,
    required this.recommendations,
  });

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Recommendations',
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
      body: recommendations.isEmpty
          ? Center(child: const Text('No recommendations available.'))
          : ListView.separated(
        padding: EdgeInsets.all(screenWidth * 0.04),
        itemCount: recommendations.length,
        separatorBuilder: (context, index) => SizedBox(
          height: mediaQuery.size.height * 0.02,
        ),
        itemBuilder: (context, index) => _buildRecommendationCard(
          context,
          recommendations[index],
          mediaQuery,
        ),
      ),
    );
  }

  Widget _buildRecommendationCard(
      BuildContext context,
      String recommendation,
      MediaQueryData mediaQuery,
      ) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: EdgeInsets.all(mediaQuery.size.width * 0.04),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              _parseTitle(recommendation),
              style: TextStyle(
                fontSize: mediaQuery.orientation == Orientation.portrait ? 18 : 16,
                fontWeight: FontWeight.bold,
                color:Color(0xFF7986CB),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              _parseDescription(recommendation),
              style: TextStyle(
                fontSize: mediaQuery.orientation == Orientation.portrait ? 16 : 14,
              ),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: _buildLearnMoreButton(context, recommendation, mediaQuery),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLearnMoreButton(
      BuildContext context,
      String recommendation,
      MediaQueryData mediaQuery,
      ) {
    return SizedBox(
      width: mediaQuery.size.width * 0.4,
      child: FilledButton.icon(
        icon: const Icon(Icons.arrow_forward, size: 18),
        label: const Text('Learn More'),
        style: FilledButton.styleFrom(
          backgroundColor: Color(0xFF7986CB),
          foregroundColor: Colors.white,
        ),
        onPressed: () => _navigateToChatbot(context, recommendation),
      ),
    );
  }

  String _parseTitle(String recommendation) => recommendation.split(RegExp(r'[:\.-]')).first.trim();

  String _parseDescription(String recommendation) {
    final index = recommendation.indexOf(RegExp(r'[:\.-]'));
    return index != -1
        ? recommendation.substring(index + 1).trim()
        : recommendation;
  }

  void _navigateToChatbot(BuildContext context, String recommendation) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ChatbotScreen(
          career: _parseTitle(recommendation),
          userAnswers: userAnswers,
        ),
      ),
    );
  }
}
