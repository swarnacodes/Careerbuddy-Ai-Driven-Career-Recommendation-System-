import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:project_career/services/gemini_ai_service.dart';

class ChatbotScreen extends StatefulWidget {
  final String career;
  final List<String> userAnswers;

  const ChatbotScreen({
    super.key,
    required this.career,
    required this.userAnswers,
  });

  @override
  _ChatbotScreenState createState() => _ChatbotScreenState();
}

class _ChatbotScreenState extends State<ChatbotScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  final GeminiApiService _geminiService = GeminiApiService();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _sendInitialPrompt();
    });
  }

  void _sendInitialPrompt() async {
    setState(() => _isLoading = true);

    final initialPrompt = '''
**System Prompt**: 
You are a friendly career advisor specialized in ${widget.career}. 
The user previously mentioned: ${widget.userAnswers.join(', ')}.
Provide a 50-word overview of ${widget.career} with key skills to learn first.
Use **bold** for headings and bullet points. Stay strictly career-focused.
''';

    try {
      final response = await _geminiService.generateChatResponse(initialPrompt);
      _addMessage(response, isUser: false);
    } catch (e) {
      _addMessage('⚠️ Error loading career information', isUser: false);
    }
    setState(() => _isLoading = false);
  }

  void _handleSubmitted(String text) async {
    if (text.isEmpty || _isLoading) return;

    _addMessage(text, isUser: true);
    _messageController.clear();

    setState(() => _isLoading = true);

    final prompt = '''
**Context**: 
- Career: ${widget.career}
- User's Background: ${widget.userAnswers.join(', ')}
- Current Question: "$text"

**Instructions**:
${text.contains('?') ? 'Answer' : 'Explain'} in markdown format with:
- Clear headings
- Bullet points for lists
- Maximum 60 words
- Only career-related content
- Friendly, encouraging tone

**Response**:''';

    try {
      final response = await _geminiService.generateChatResponse(prompt);
      _addMessage(response, isUser: false);
    } catch (e) {
      _addMessage('🚨 Error processing your request', isUser: false);
    }
    setState(() => _isLoading = false);
  }

  void _addMessage(String text, {required bool isUser}) {
    setState(() {
      _messages.add(ChatMessage(
        text: text,
        isUser: isUser,
      ));
      _scrollToBottom();
    });
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Career Assistant',
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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(8),
              itemCount: _messages.length + (_isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == _messages.length) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: CircularProgressIndicator()),
                  );
                }
                return _messages[index];
              },
            ),
          ),
          _buildMessageInput(),
        ],
      ),
    );
  }

  Widget _buildMessageInput() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      color: Colors.grey[200],
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _messageController,
              enabled: !_isLoading,
              decoration: InputDecoration(
                hintText: _isLoading
                    ? 'Generating response...'
                    : 'Ask about ${widget.career}...',
                border: InputBorder.none,
              ),
              onSubmitted: _handleSubmitted,
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.send,
              color: _isLoading ? Colors.grey : Color(0xFF7986CB),
            ),
            onPressed: _isLoading ? null : () => _handleSubmitted(_messageController.text),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }
}

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isUser;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isUser,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Container(
            constraints: BoxConstraints(
              maxWidth: MediaQuery.of(context).size.width * 0.8,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 12,
            ),
            decoration: BoxDecoration(
              color: isUser ? Color(0xFF7986CB) : Colors.grey[300],
              borderRadius: BorderRadius.circular(20),
            ),
            child: MarkdownBody(
              data: text,
              selectable: true,
              styleSheet: MarkdownStyleSheet(
                p: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                  fontSize: 16,
                ),
                strong: TextStyle(
                  color: isUser ? Colors.amber[100] : Color(0xFF7986CB),
                  fontWeight: FontWeight.bold,
                ),
                listBullet: TextStyle(
                  color: isUser ? Colors.white : Colors.black87,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}