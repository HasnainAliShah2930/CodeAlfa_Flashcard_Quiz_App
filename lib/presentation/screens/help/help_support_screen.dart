import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';

class HelpSupportScreen extends StatelessWidget {
  const HelpSupportScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('Help & Support', style: AppTextStyles.heading3),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Welcome to Flashcard Quiz!',
              style: AppTextStyles.heading2.copyWith(color: AppColors.primary),
            ),
            const SizedBox(height: 12),
            Text(
              "We're committed to providing a smooth and inspiring experience. If you have any questions, encounter any issues, or would like to share feedback, we're here to help.",
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 24),
            _SectionTitle(title: 'App Features'),
            _BulletItem(text: 'Study smart with interactive flashcards across various categories.'),
            _BulletItem(text: 'Track your progress with real-time statistics and "Recently Studied" insights.'),
            _BulletItem(text: 'Add, edit, or delete your own custom flashcards easily.'),
            _BulletItem(text: 'Bookmark challenging cards to review them later.'),
            _BulletItem(text: 'Clean and intuitive interface designed for focused learning.'),
            const SizedBox(height: 24),
            _SectionTitle(title: 'Frequently Asked Questions'),
            _FaqItem(
              question: '1. How do I start a quiz?',
              answer: 'Simply tap on any category card from the home screen to start studying that set of cards.',
            ),
            _FaqItem(
              question: '2. Can I add my own cards?',
              answer: 'Yes! Tap the "Add New Flashcard" button on the Home or My Flashcards screen to create your own content.',
            ),
            _FaqItem(
              question: '3. How does the "Studied" count work?',
              answer: 'When you tap "Next" or "Got it" in a quiz, that card is marked as studied and added to your daily progress.',
            ),
            _FaqItem(
              question: '4. Does the app work offline?',
              answer: 'Yes, the app works completely offline as all your flashcards are stored locally on your device.',
            ),
            const SizedBox(height: 24),
            _SectionTitle(title: 'Troubleshooting'),
            _BulletItem(text: 'Make sure you\'re using the latest version of the app.'),
            _BulletItem(text: 'Restart the app if you experience unexpected behavior.'),
            _BulletItem(text: 'If a problem persists, please contact our support team.'),
            const SizedBox(height: 24),
            _SectionTitle(title: 'Feedback & Suggestions'),
            Text(
              "Your feedback helps us improve the app. If you have ideas for new features, discover a bug, or want to suggest improvements, we'd love to hear from you.",
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 16),
            _SectionTitle(title: 'Contact Us'),
            Text(
              'Email: hasnainalishahg2930@gmail.com',
              style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600, color: AppColors.primary),
            ),
            const SizedBox(height: 24),
            _SectionTitle(title: 'Privacy & Security'),
            Text(
              'Your privacy is important to us. We do not collect personal information unless it is required for specific features. Any saved flashcards or settings are stored securely on your device.',
              style: AppTextStyles.body,
            ),
            const SizedBox(height: 24),
            _SectionTitle(title: 'Version Information'),
            Text('App Name: Flashcard Quiz', style: AppTextStyles.body),
            Text('Version: 1.0.0', style: AppTextStyles.body),
            Text('Developer: Hasnain Ali Shah / CodeAlpha Internship Project', style: AppTextStyles.body),
            const SizedBox(height: 40),
            Center(
              child: Text(
                'Thank you for using Flashcard Quiz!\nKeep reading, keep learning, and stay inspired every day.',
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySecondary.copyWith(fontStyle: FontStyle.italic),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Text(
        title,
        style: AppTextStyles.heading3.copyWith(color: AppColors.primary),
      ),
    );
  }
}

class _BulletItem extends StatelessWidget {
  final String text;
  const _BulletItem({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 6),
            child: Icon(Icons.circle, size: 6, color: AppColors.textSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(text, style: AppTextStyles.body)),
        ],
      ),
    );
  }
}

class _FaqItem extends StatelessWidget {
  final String question;
  final String answer;
  const _FaqItem({required this.question, required this.answer});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(question, style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(answer, style: AppTextStyles.bodySecondary),
        ],
      ),
    );
  }
}
