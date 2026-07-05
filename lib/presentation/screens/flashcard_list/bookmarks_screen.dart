import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/confirm_action_dialog.dart';
import '../../../core/widgets/empty_state.dart';
import '../../../core/widgets/flashcard_list_tile.dart';
import '../../bloc/flashcard/flashcard_bloc.dart';
import '../../bloc/flashcard/flashcard_event.dart';
import '../../bloc/flashcard/flashcard_state.dart';

class BookmarksScreen extends StatelessWidget {
  const BookmarksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text('Bookmarks', style: AppTextStyles.heading3),
      ),
      body: BlocBuilder<FlashcardBloc, FlashcardState>(
        builder: (context, state) {
          final bookmarks = state.bookmarkedFlashcards;
          if (bookmarks.isEmpty) {
            return const EmptyState(
              icon: Icons.bookmark_border,
              title: 'No bookmarks yet',
              message: 'Bookmark flashcards while studying to find them here.',
            );
          }
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: bookmarks.length,
            itemBuilder: (context, index) {
              final card = bookmarks[index];
              return FlashcardListTile(
                flashcard: card,
                onTapEdit: () => context.push('/flashcard/edit/${card.id}'),
                onToggleBookmark: () => context.read<FlashcardBloc>().add(FlashcardBookmarkToggled(card.id)),
                onDelete: () => showDialog(
                  context: context,
                  builder: (_) => ConfirmActionDialog(
                    icon: Icons.delete_outline,
                    title: 'Delete Flashcard',
                    message: 'Are you sure you want to delete this flashcard? This action cannot be undone.',
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
          );
        },
      ),
    );
  }
}
