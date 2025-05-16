// widgets/question_widget.dart
import 'package:flutter/material.dart';

class QuestionWidget extends StatelessWidget {
  final String question;
  final List<String> options;
  final ValueChanged<String> onOptionSelected;

  const QuestionWidget({
    Key? key,
    required this.question,
    required this.options,
    required this.onOptionSelected,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              question,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8.0,
              children: options.map((option) {
                return ElevatedButton(
                  onPressed: () => onOptionSelected(option),
                  child: Text(option),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}