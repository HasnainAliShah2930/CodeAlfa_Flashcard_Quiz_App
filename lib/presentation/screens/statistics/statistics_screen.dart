import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/stat_card.dart';
import '../../bloc/flashcard/flashcard_bloc.dart';
import '../../bloc/flashcard/flashcard_state.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.appBarTheme.foregroundColor),
          onPressed: () => context.pop(),
        ),
        title: Text('Statistics', style: AppTextStyles.heading3),
      ),
      body: BlocBuilder<FlashcardBloc, FlashcardState>(
        builder: (context, state) {
          return ListView(
            padding: const EdgeInsets.all(20),
            children: [
              Row(
                children: [
                  Expanded(
                    child: StatCard(
                      value: '${state.totalCards}',
                      label: 'Total Cards',
                      backgroundColor: AppColors.statBlueBg,
                      valueColor: AppColors.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      value: '${state.studiedCount}',
                      label: 'Studied',
                      backgroundColor: AppColors.statOrangeBg,
                      valueColor: AppColors.warning,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: StatCard(
                      value: '${state.bookmarkedFlashcards.length}',
                      label: 'Bookmarked',
                      backgroundColor: AppColors.statGreenBg,
                      valueColor: AppColors.success,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 28),
              Text(
                'Progress by Category', 
                style: AppTextStyles.heading3.copyWith(color: theme.textTheme.titleLarge?.color)
              ),
              const SizedBox(height: 16),
              ...state.categories.map((category) {
                final cards = state.flashcardsByCategory(category.id);
                final studied = cards.where((c) => c.hasBeenStudied).length;
                final ratio = cards.isEmpty ? 0.0 : studied / cards.length;
                return Padding(
                  padding: const EdgeInsets.only(bottom: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(category.icon, size: 16, color: category.color),
                              const SizedBox(width: 8),
                              Text(
                                category.name, 
                                style: AppTextStyles.body.copyWith(color: theme.textTheme.bodyLarge?.color)
                              ),
                            ],
                          ),
                          Text(
                            '$studied / ${cards.length}', 
                            style: AppTextStyles.bodySecondary.copyWith(color: theme.textTheme.bodySmall?.color)
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: LinearProgressIndicator(
                          value: ratio,
                          minHeight: 8,
                          backgroundColor: theme.dividerColor,
                          color: category.color,
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ],
          );
        },
      ),
    );
  }
}
