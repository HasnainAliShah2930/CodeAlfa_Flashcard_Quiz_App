import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/confirm_action_dialog.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/flashcard_list_tile.dart';
import '../../bloc/flashcard/flashcard_bloc.dart';
import '../../bloc/flashcard/flashcard_event.dart';
import '../../bloc/flashcard/flashcard_state.dart';

class FlashcardListScreen extends StatelessWidget {
  final String categoryId;

  const FlashcardListScreen({super.key, required this.categoryId});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashcardBloc, FlashcardState>(
      builder: (context, state) {
        final category = state.categoryById(categoryId);
        final cards = state.flashcardsByCategory(categoryId);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            title: Text(category?.name ?? 'Flashcards', style: AppTextStyles.heading3),
          ),
          body: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Expanded(
                  child: cards.isEmpty
                      ? const EmptyState(
                          icon: Icons.style_outlined,
                          title: 'No flashcards here yet',
                          message: 'Tap "Add New Flashcard" to create your first one.',
                        )
                      : ListView.builder(
                          itemCount: cards.length,
                          itemBuilder: (context, index) {
                            final card = cards[index];
                            return FlashcardListTile(
                              flashcard: card,
                              onTapEdit: () => context.push('/flashcard/edit/${card.id}'),
                              onToggleBookmark: () =>
                                  context.read<FlashcardBloc>().add(FlashcardBookmarkToggled(card.id)),
                              onDelete: () => showDialog(
                                context: context,
                                builder: (_) => ConfirmActionDialog(
                                  icon: Icons.delete_outline,
                                  title: 'Delete Flashcard',
                                  message: 'Are you sure you want to delete this flashcard? '
                                      'This action cannot be undone.',
                                  confirmLabel: 'Delete',
                                  onConfirm: () {
                                    context.read<FlashcardBloc>().add(FlashcardDeleteRequested(card.id));
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Flashcard deleted')),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                ),
                const SizedBox(height: 12),
                AppButton(
                  label: 'Add New Flashcard',
                  icon: Icons.add,
                  onPressed: () => context.push('/flashcard/add?categoryId=$categoryId'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
