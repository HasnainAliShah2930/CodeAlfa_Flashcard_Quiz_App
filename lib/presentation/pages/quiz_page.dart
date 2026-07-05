import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../routes/injection_container.dart';
import '../bloc/quiz/quiz_bloc.dart';
import '../bloc/quiz/quiz_event.dart';
import '../bloc/quiz/quiz_state.dart';
import 'result_page.dart';

class QuizPage extends StatelessWidget {
  final String categoryId;
  final String categoryName;

  const QuizPage({
    super.key,
    required this.categoryId,
    required this.categoryName,
  });

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => sl<QuizBloc>()..add(LoadQuiz(categoryId)),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text(
            categoryName,
            style: const TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 18,
            ),
          ),
          centerTitle: true,
          actions: [
            BlocBuilder<QuizBloc, QuizState>(
              builder: (context, state) {
                if (state is QuizLoaded) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0, top: 18),
                    child: Text(
                      '${state.currentIndex + 1} / ${state.flashcards.length}',
                      style: const TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
        body: BlocConsumer<QuizBloc, QuizState>(
          listener: (context, state) {
            if (state is QuizFinished) {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => ResultPage(
                    correctAnswers: state.correctCount,
                    totalQuestions: state.totalCount,
                  ),
                ),
              );
            }
          },
          builder: (context, state) {
            if (state is QuizLoading || state is QuizInitial) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is QuizError) {
              return Center(child: Text(state.message));
            } else if (state is QuizLoaded) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 8),
                    // Progress Bar
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: LinearProgressIndicator(
                        value: (state.currentIndex + 1) / state.flashcards.length,
                        backgroundColor: const Color(0xFFF3F4F6),
                        valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF6A4BC1)),
                        minHeight: 6,
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Flashcard
                    Expanded(
                      child: Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(color: const Color(0xFFF3F4F6), width: 1),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.02),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Question/Answer Tag
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: state.isFlipped ? const Color(0xFFF0FDF4) : const Color(0xFFF5F3FF),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                state.isFlipped ? 'Answer' : 'Question',
                                style: TextStyle(
                                  color: state.isFlipped ? const Color(0xFF22C55E) : const Color(0xFF6A4BC1),
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                            const SizedBox(height: 32),
                            // Question Text
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 24.0),
                              child: Text(
                                state.isFlipped ? state.currentCard.answer : state.currentCard.question,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.bold,
                                  color: Color(0xFF1F2937),
                                  height: 1.4,
                                ),
                              ),
                            ),
                            const SizedBox(height: 48),
                            // Show Answer Button
                            SizedBox(
                              width: 180,
                              height: 50,
                              child: ElevatedButton.icon(
                                onPressed: () => context.read<QuizBloc>().add(FlipCard()),
                                icon: Icon(
                                  state.isFlipped ? Icons.visibility_off_outlined : Icons.visibility_outlined,
                                  size: 20,
                                ),
                                label: Text(state.isFlipped ? 'Show Question' : 'Show Answer'),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6A4BC1),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  elevation: 0,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 32),
                    // Navigation Buttons
                    Padding(
                      padding: const EdgeInsets.only(bottom: 32.0),
                      child: Row(
                        children: [
                          // Previous Button
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: OutlinedButton.icon(
                                onPressed: state.currentIndex > 0 
                                  ? () => context.read<QuizBloc>().add(PreviousCard())
                                  : null,
                                icon: const Icon(Icons.arrow_back, size: 20),
                                label: const Text('Previous'),
                                style: OutlinedButton.styleFrom(
                                  foregroundColor: Colors.black,
                                  side: const BorderSide(color: Color(0xFFF3F4F6)),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Bookmark Button
                          Container(
                            height: 56,
                            width: 56,
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FB),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: const Color(0xFFF3F4F6)),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.bookmark_border, color: Colors.black),
                              onPressed: () {},
                            ),
                          ),
                          const SizedBox(width: 12),
                          // Next Button
                          Expanded(
                            child: SizedBox(
                              height: 56,
                              child: ElevatedButton(
                                onPressed: () => context.read<QuizBloc>().add(MarkStudied(state.currentCard.id)),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF6A4BC1),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                  elevation: 0,
                                ),
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('Next'),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward, size: 20),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }
}
