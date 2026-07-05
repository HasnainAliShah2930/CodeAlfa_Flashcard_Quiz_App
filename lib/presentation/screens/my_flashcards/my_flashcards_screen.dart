import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/app_drawer.dart';
import '../../../core/widgets/category_card.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../bloc/flashcard/flashcard_bloc.dart';
import '../../bloc/flashcard/flashcard_event.dart';
import '../../bloc/flashcard/flashcard_state.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../bloc/settings/settings_state.dart';

class MyFlashcardsScreen extends StatefulWidget {
  const MyFlashcardsScreen({super.key});

  @override
  State<MyFlashcardsScreen> createState() => _MyFlashcardsScreenState();
}

class _MyFlashcardsScreenState extends State<MyFlashcardsScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, settingsState) {
        return Scaffold(
          backgroundColor: theme.scaffoldBackgroundColor,
          drawer: const AppDrawer(currentRoute: '/my-flashcards'),
          appBar: AppBar(
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: theme.appBarTheme.foregroundColor),
              onPressed: () => context.pop(),
            ),
            title: Text('My Flashcards', style: AppTextStyles.heading3),
          ),
          body: BlocBuilder<FlashcardBloc, FlashcardState>(
            builder: (context, state) {
              final isSearching = state.searchQuery.trim().isNotEmpty;

              return Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    TextField(
                      controller: _searchController,
                      style: TextStyle(color: theme.textTheme.bodyLarge?.color),
                      onChanged: (value) => context.read<FlashcardBloc>().add(FlashcardSearchQueryChanged(value)),
                      decoration: InputDecoration(
                        hintText: 'Search flashcards...',
                        hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
                        prefixIcon: const Icon(Icons.search, color: AppColors.textSecondary),
                        fillColor: theme.cardColor,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: BorderSide(color: theme.dividerColor),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: isSearching
                          ? _SearchResultsList(state: state)
                          : state.categories.isEmpty
                              ? const EmptyState(
                                  icon: Icons.style_outlined,
                                  title: 'No categories yet',
                                  message: 'Add a flashcard to get started.',
                                )
                              : ListView.separated(
                                  itemCount: state.categories.length,
                                  separatorBuilder: (context, index) => const SizedBox(height: 12),
                                  itemBuilder: (context, index) {
                                    final category = state.categories[index];
                                    return CategoryCard(
                                      category: category,
                                      cardCount: state.cardCountForCategory(category.id),
                                      onTap: () => context.push('/category/${category.id}/list'),
                                      trailing: const Icon(Icons.chevron_right, color: AppColors.textSecondary),
                                    );
                                  },
                                ),
                    ),
                    const SizedBox(height: 16),
                    AppButton(
                      label: 'Add New Flashcard',
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

class _SearchResultsList extends StatelessWidget {
  final FlashcardState state;

  const _SearchResultsList({required this.state});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final results = state.searchResults;
    
    if (results.isEmpty) {
      return const EmptyState(
        icon: Icons.search_off,
        title: 'No results',
        message: 'Try a different search term.',
      );
    }
    return ListView.separated(
      itemCount: results.length,
      separatorBuilder: (context, index) => const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final card = results[index];
        final category = state.categoryById(card.categoryId);
        return ListTile(
          tileColor: theme.cardColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
            side: BorderSide(color: theme.dividerColor),
          ),
          leading: Icon(category?.icon ?? Icons.style, color: category?.color ?? AppColors.primary),
          title: Text(
            card.question, 
            maxLines: 1, 
            overflow: TextOverflow.ellipsis, 
            style: AppTextStyles.body.copyWith(color: theme.textTheme.bodyLarge?.color)
          ),
          subtitle: Text(
            category?.name ?? '', 
            style: AppTextStyles.caption.copyWith(color: theme.textTheme.bodySmall?.color)
          ),
          onTap: () => context.push('/flashcard/edit/${card.id}'),
        );
      },
    );
  }
}
