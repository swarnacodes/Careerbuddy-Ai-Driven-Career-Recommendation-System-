import 'package:flutter/material.dart';
import 'package:project_career/screens/questions_screen.dart';
import 'package:flutter/animation.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background with Subtle Gradient and Dynamic Shapes
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0xFFE1F5FE), // Light Sky Blue
                  Color(0xFFCFE8FC), // Lighter Sky Blue
                ],
              ),
            ),
          ),

          // App Name at Top
          Positioned(
            top: 40,
            left: 20,
            child: Text(
              "CareerBuddy",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w600,
                color: Color(0xFF37474F),
                fontFamily: 'Roboto',
              ),
            ),
          ),

          // Illustration (Smaller and Higher)
          Center(
            child: Padding(
              padding: const EdgeInsets.only(top: 5, bottom: 200), // Adjusted padding
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Image.asset(
                    'assets/images/career_exploration.png',
                    fit: BoxFit.contain,
                    height: 380, // Reduced height
                    filterQuality: FilterQuality.high,
                  ),
                ],
              ),
            ),
          ),

          // Content Container with Elevated Effect
          Positioned(
            bottom: 80,
            left: 20,
            right: 20,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 30, vertical: 40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 20,
                    spreadRadius: 3,
                    offset: Offset(0, 6),
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Welcome to CareerBuddy!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF37474F),
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Explore your ideal career path with personalized guidance.",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 15,
                      color: Color(0xFF546E7A),
                      fontFamily: 'Roboto',
                    ),
                  ),
                  SizedBox(height: 30),
                  Container(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => QuestionsScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF7986CB), // Slate Blue
                        padding: EdgeInsets.symmetric(vertical: 18, horizontal: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                        elevation: 4,
                      ),
                      child: Text(
                        "Get Started",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}