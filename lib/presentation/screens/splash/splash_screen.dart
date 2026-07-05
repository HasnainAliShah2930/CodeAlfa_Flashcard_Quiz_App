import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_text_styles.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF6A4BC1),
      body: Stack(
        children: [
          // Background Sparkles (Stars)
          Positioned(
            top: 100,
            right: 60,
            child: Icon(Icons.auto_awesome, color: Colors.white.withValues(alpha: 0.3), size: 24),
          ),
          Positioned(
            bottom: 350,
            left: 50,
            child: Icon(Icons.auto_awesome, color: Colors.white.withValues(alpha: 0.3), size: 30),
          ),
          
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),
                  
                  // Flashcards Image with Circular Glow
                  Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 260,
                        height: 260,
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                      ),
                      Image.asset(
                        'assects/card.png',
                        width: 200,
                        height: 200,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) => 
                            const Icon(Icons.style, size: 100, color: Colors.white),
                      ),
                    ],
                  ),
                  
                  const SizedBox(height: 50),
                  
                  // Title
                  Text(
                    'Flashcard\nQuiz',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.heading1.copyWith(
                      color: Colors.white, 
                      fontSize: 48,
                      height: 1.1,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 20),
                  
                  // Subtitle
                  Text(
                    'Study smart with flashcards',
                    style: AppTextStyles.body.copyWith(
                      color: Colors.white.withValues(alpha: 0.8),
                      fontSize: 18,
                    ),
                  ),
                  
                  const Spacer(flex: 4),
                  
                  // Get Started Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      width: double.infinity,
                      height: 65,
                      child: ElevatedButton(
                        onPressed: () => context.go('/home'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: const Color(0xFF6A4BC1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          elevation: 0,
                        ),
                        child: Text(
                          'Get Started',
                          style: AppTextStyles.button.copyWith(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  
                  const SizedBox(height: 60),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
