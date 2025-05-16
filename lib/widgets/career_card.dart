import 'package:flutter/material.dart';

class CareerCard extends StatelessWidget {
  final String career;
  final VoidCallback onTap;

  CareerCard({required this.career, required this.onTap, required description});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(8.0),
      child: InkWell( // Use InkWell for tap functionality
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(career, style: TextStyle(fontSize: 18)),
        ),
      ),
    );
  }
}