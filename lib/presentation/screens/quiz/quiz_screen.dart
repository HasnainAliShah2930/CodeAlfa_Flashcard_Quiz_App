import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../bloc/flashcard/flashcard_bloc.dart';
import '../../bloc/flashcard/flashcard_event.dart';
import '../../bloc/flashcard/flashcard_state.dart';
import '../../bloc/quiz/quiz_bloc.dart';
import '../../bloc/quiz/quiz_event.dart';
import '../../bloc/quiz/quiz_state.dart';
import '../../../routes/injection_container.dart';

class QuizScreen extends StatelessWidget {
  final String categoryId;

  const QuizScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<QuizBloc>()..add(LoadQuiz(categoryId)),
      child: _QuizView(categoryId: categoryId),
    );
  }
}

class _QuizView extends StatelessWidget {
  final String categoryId;

  const _QuizView({required this.categoryId});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocBuilder<FlashcardBloc, FlashcardState>(
      builder: (context, flashcardState) {
        final category = flashcardState.categoryById(categoryId);

        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.appBarTheme.foregroundColor),
              onPressed: () => context.pop(),
            ),
            title: Text(
              category?.name ?? 'Study', 
              style: AppTextStyles.heading3.copyWith(color: theme.appBarTheme.foregroundColor)
            ),
          ),
          body: BlocConsumer<QuizBloc, QuizState>(
            listener: (context, quizState) {
              if (quizState is QuizFinished) {
                _showCompletionDialog(context, quizState.totalCount);
              }
            },
            builder: (context, quizState) {
              if (quizState is QuizLoading || quizState is QuizInitial) {
                return const Center(child: CircularProgressIndicator());
              }
              
              if (quizState is QuizError) {
                return EmptyState(
                  icon: Icons.error_outline,
                  title: 'Oops!',
                  message: quizState.message,
                );
              }

              if (quizState is QuizLoaded) {
                final card = quizState.currentCard;
                final cardsCount = quizState.flashcards.length;

                return Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${quizState.currentIndex + 1} / $cardsCount',
                              style: AppTextStyles.bodySecondary.copyWith(color: theme.textTheme.bodySmall?.color),
                              textAlign: TextAlign.right,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: (quizState.currentIndex + 1) / cardsCount,
                          minHeight: 6,
                          backgroundColor: theme.dividerColor,
                          color: AppColors.primary,
                        ),
                      ),
                      const SizedBox(height: 24),
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(24),
                          decoration: BoxDecoration(
                            color: theme.cardColor,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: theme.dividerColor),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                                decoration: BoxDecoration(
                                  color: quizState.isFlipped
                                      ? AppColors.success.withValues(alpha: 0.1)
                                      : AppColors.primary.withValues(alpha: 0.1),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  quizState.isFlipped ? 'Answer' : 'Question',
                                  style: AppTextStyles.caption.copyWith(
                                    color: quizState.isFlipped ? AppColors.success : AppColors.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 20),
                              Expanded(
                                child: SingleChildScrollView(
                                  child: Text(
                                    quizState.isFlipped ? card.answer : card.question,
                                    style: AppTextStyles.body.copyWith(
                                      fontSize: quizState.isFlipped ? 16 : 22,
                                      fontWeight: quizState.isFlipped ? FontWeight.normal : FontWeight.bold,
                                      height: 1.4,
                                      color: theme.textTheme.bodyLarge?.color,
                                    ),
                                  ),
                                ),
                              ),
                              if (!quizState.isFlipped)
                                AppButton(
                                  label: 'Show Answer',
                                  icon: Icons.remove_red_eye_outlined,
                                  onPressed: () {
                                    context.read<QuizBloc>().add(FlipCard());
                                  },
                                ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Row(
                        children: [
                          Expanded(
                            child: AppButton(
                              label: 'Previous',
                              icon: Icons.arrow_back,
                              variant: AppButtonVariant.outline,
                              onPressed: quizState.currentIndex == 0
                                  ? null
                                  : () => context.read<QuizBloc>().add(PreviousCard()),
                            ),
                          ),
                          const SizedBox(width: 12),
                          IconButton(
                            onPressed: () => context.read<FlashcardBloc>().add(FlashcardBookmarkToggled(card.id)),
                            icon: Icon(
                              card.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                              color: card.isBookmarked ? AppColors.primary : AppColors.textSecondary,
                            ),
                            style: IconButton.styleFrom(
                              backgroundColor: theme.cardColor,
                              side: BorderSide(color: theme.dividerColor),
                              padding: const EdgeInsets.all(14),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: AppButton(
                              label: 'Next',
                              icon: Icons.arrow_forward,
                              onPressed: () =>
                                  context.read<QuizBloc>().add(MarkStudied(card.id)),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              }
              return const SizedBox.shrink();
            },
          ),
        );
      },
    );
  }

  void _showCompletionDialog(BuildContext context, int totalCards) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (dialogContext) => AlertDialog(
        backgroundColor: Theme.of(context).cardColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Great job! 🎉', style: AppTextStyles.heading3),
        content: Text('You went through all $totalCards flashcards in this category.',
            style: AppTextStyles.bodySecondary),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.read<QuizBloc>().add(LoadQuiz(categoryId));
            },
            child: const Text('Study Again'),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              context.pop();
            },
            child: const Text('Done'),
          ),
        ],
      ),
    );
  }
}
