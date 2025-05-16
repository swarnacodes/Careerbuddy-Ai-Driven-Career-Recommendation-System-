import 'package:http/http.dart' as http;
import 'dart:convert';

class GeminiApiService {
  static const String _apiKey = 'apiKey';
  static const String _baseUrl = 'baseUrl';

  // Existing career recommendations method (used in questions_screen.dart)
  Future<List<String>> generateCareerRecommendations(String userInput) async {
    try {
      final url = Uri.parse('$_baseUrl?key=$_apiKey');
      final body = _buildCareerRequestBody(userInput);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      ).timeout(const Duration(seconds: 30));

      return _handleCareerResponse(response);
    } catch (e) {
      throw Exception('Failed to generate recommendations: ${e.toString()}');
    }
  }

  // New chat response method (for chatbot_screen.dart)
  Future<String> generateChatResponse(String prompt) async {
    try {
      final url = Uri.parse('$_baseUrl?key=$_apiKey');
      final body = _buildChatRequestBody(prompt);

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      ).timeout(const Duration(seconds: 30));

      return _handleChatResponse(response);
    } catch (e) {
      throw Exception('Failed to generate chat response: ${e.toString()}');
    }
  }

  String _buildCareerRequestBody(String input) => jsonEncode({
    "contents": [{
      "parts": [{
        "text": "You are a career advisor. Provide 5 specific recommendations in this format:\n"
            "1. [Career Title]: [Brief Description]\n"
            "2. [Career Title]: [Brief Description]\n"
            "$input"
      }]
    }],
    "generationConfig": {
      "maxOutputTokens": 1000,
      "temperature": 0.5
    }
  });

  String _buildChatRequestBody(String prompt) => jsonEncode({
    "contents": [{
      "parts": [{
        "text": "You are a friendly career chatbot. $prompt "
            "Respond in markdown with brief, focused answers (40-60 words). "
            "Use bullet points and bold headings. Stay strictly career-focused."
      }]
    }],
    "generationConfig": {
      "maxOutputTokens": 500,
      "temperature": 0.7
    }
  });

  List<String> _handleCareerResponse(http.Response response) {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final responseText = data['candidates'][0]['content']['parts'][0]['text'] as String;
      return _parseRecommendations(responseText);
    }
    throw Exception('API Error: ${response.statusCode}');
  }

  String _handleChatResponse(http.Response response) {
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data['candidates'][0]['content']['parts'][0]['text'] as String;
    }
    throw Exception('API Error: ${response.statusCode}');
  }

  List<String> _parseRecommendations(String rawText) => rawText.split('\n')
      .where((line) => line.trim().isNotEmpty)
      .map((line) => line.trim())
      .toList();
}