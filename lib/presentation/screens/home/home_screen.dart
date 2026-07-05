import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:timeago/timeago.dart' as timeago;
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/localization/app_localizations.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/category_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/stat_card.dart';
import '../../bloc/flashcard/flashcard_bloc.dart';
import '../../bloc/flashcard/flashcard_event.dart';
import '../../bloc/flashcard/flashcard_state.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../bloc/settings/settings_state.dart';
import '../../../data/models/notification_model.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FlashcardBloc>().add(FlashcardsLoadRequested());
  }

  void _showNotifications(BuildContext context, FlashcardState state) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Notifications', style: AppTextStyles.heading3),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Expanded(
              child: state.notifications.isEmpty
                  ? const Center(child: Text('No new notifications'))
                  : ListView.builder(
                      itemCount: state.notifications.length,
                      itemBuilder: (context, index) {
                        final note = state.notifications[index];
                        return ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: CircleAvatar(
                            backgroundColor: note.type == NotificationType.added 
                                ? AppColors.success.withValues(alpha: 0.1)
                                : AppColors.danger.withValues(alpha: 0.1),
                            child: Icon(
                              note.type == NotificationType.added ? Icons.add : Icons.delete_outline,
                              color: note.type == NotificationType.added ? AppColors.success : AppColors.danger,
                              size: 20,
                            ),
                          ),
                          title: Text(note.message, style: AppTextStyles.body),
                          subtitle: Text(
                            DateFormat('MMM d, h:mm a').format(note.timestamp),
                            style: AppTextStyles.caption,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        final code = settingsState.languageCode;
        
        return Scaffold(
          drawer: const AppDrawer(currentRoute: '/home'),
          appBar: AppBar(
            title: Text('Flashcard Quiz', style: AppTextStyles.heading3.copyWith(color: AppColors.primary)),
            actions: [
              BlocBuilder<FlashcardBloc, FlashcardState>(
                builder: (context, flashcardState) {
                  return Stack(
                    children: [
                      IconButton(
                        onPressed: () => _showNotifications(context, flashcardState), 
                        icon: const Icon(Icons.notifications_none)
                      ),
                      if (flashcardState.notifications.isNotEmpty)
                        Positioned(
                          right: 12,
                          top: 12,
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: AppColors.danger,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ],
          ),
          body: BlocBuilder<FlashcardBloc, FlashcardState>(
            builder: (context, state) {
              if (state.status == FlashcardStatus.loading || state.status == FlashcardStatus.initial) {
                return const Center(child: CircularProgressIndicator(color: AppColors.primary));
              }

              final categories = state.categories.take(3).toList();
              final recentlyStudied = state.recentlyStudied.take(3).toList();

              return RefreshIndicator(
                color: AppColors.primary,
                onRefresh: () async => context.read<FlashcardBloc>().add(FlashcardsLoadRequested()),
                child: ListView(
                  padding: const EdgeInsets.all(20),
                  children: [
                    Text(
                      AppTranslations.getString(code, 'hello').replaceFirst('{name}', settingsState.userName),
                      style: AppTextStyles.heading2
                    ),
                    const SizedBox(height: 4),
                    Text(AppTranslations.getString(code, 'keep_learning'), style: AppTextStyles.bodySecondary),
                    const SizedBox(height: 20),
                    Row(
                      children: [
                        Expanded(
                          child: StatCard(
                            value: '${state.totalCards}',
                            label: AppTranslations.getString(code, 'total_cards'),
                            backgroundColor: AppColors.statBlueBg,
                            valueColor: AppColors.primary,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            value: '${state.totalCategories}',
                            label: AppTranslations.getString(code, 'categories'),
                            backgroundColor: AppColors.statGreenBg,
                            valueColor: AppColors.success,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: StatCard(
                            value: '${state.studiedCount}',
                            label: AppTranslations.getString(code, 'studied'),
                            backgroundColor: AppColors.statOrangeBg,
                            valueColor: AppColors.warning,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 28),
                    _SectionHeader(
                      title: AppTranslations.getString(code, 'categories'), 
                      onViewAll: () => context.push('/categories'),
                      viewAllLabel: AppTranslations.getString(code, 'view_all'),
                    ),
                    const SizedBox(height: 12),
                    ...categories.map((category) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: CategoryCard(
                            category: category,
                            cardCount: state.cardCountForCategory(category.id),
                            onTap: () => context.push('/category/${category.id}'),
                          ),
                        )),
                    const SizedBox(height: 16),
                    _SectionHeader(
                      title: AppTranslations.getString(code, 'recently_studied'), 
                      onViewAll: () => context.push('/statistics'),
                      viewAllLabel: AppTranslations.getString(code, 'view_all'),
                    ),
                    const SizedBox(height: 12),
                    if (recentlyStudied.isEmpty)
                      Text('No cards studied yet — start a quiz!', style: AppTextStyles.bodySecondary)
                    else
                      ...recentlyStudied.map((card) {
                        final category = state.categoryById(card.categoryId);
                        return Container(
                          margin: const EdgeInsets.only(bottom: 10),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Theme.of(context).cardColor,
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(color: AppColors.border),
                          ),
                          child: Row(
                            children: [
                              Container(
                                width: 36,
                                height: 36,
                                decoration: BoxDecoration(
                                  color: (category?.color ?? AppColors.primary).withValues(alpha: 0.12),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: Icon(category?.icon ?? Icons.style, color: category?.color ?? AppColors.primary, size: 18),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(category?.name ?? 'Flashcard',
                                        style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
                                    Text('Last studied: ${timeago.format(card.lastStudiedAt!)}',
                                        style: AppTextStyles.caption),
                                  ],
                                ),
                              ),
                              CircleAvatar(
                                radius: 14,
                                backgroundColor: Theme.of(context).scaffoldBackgroundColor,
                                child: Text('${card.studyCount}', style: AppTextStyles.caption),
                              ),
                            ],
                          ),
                        );
                      }),
                    const SizedBox(height: 20),
                    AppButton(
                      label: AppTranslations.getString(code, 'add_new'),
                      icon: Icons.add,
                      onPressed: () => context.push('/flashcard/add'),
                    ),
                  ],
                ),
              );
            },
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String viewAllLabel;
  final VoidCallback onViewAll;

  const _SectionHeader({
    required this.title, 
    required this.onViewAll,
    required this.viewAllLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(title, style: AppTextStyles.heading3),
        GestureDetector(
          onTap: onViewAll,
          child: Text(viewAllLabel, style: AppTextStyles.bodySecondary.copyWith(color: AppColors.primary)),
        ),
      ],
    );
  }
}
