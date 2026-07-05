import 'package:flutter/material.dart';
import '../../data/models/flashcard_model.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';

class FlashcardListTile extends StatelessWidget {
  final FlashcardModel flashcard;
  final VoidCallback onTapEdit;
  final VoidCallback onDelete;
  final VoidCallback onToggleBookmark;

  const FlashcardListTile({
    super.key,
    required this.flashcard,
    required this.onTapEdit,
    required this.onDelete,
    required this.onToggleBookmark,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: theme.cardColor,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: theme.dividerColor),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: GestureDetector(
              onTap: onTapEdit,
              child: Text(
                flashcard.question,
                style: AppTextStyles.body.copyWith(
                  fontWeight: FontWeight.w600,
                  color: theme.textTheme.bodyLarge?.color,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          IconButton(
            onPressed: onToggleBookmark,
            icon: Icon(
              flashcard.isBookmarked ? Icons.bookmark : Icons.bookmark_border,
              color: flashcard.isBookmarked ? AppColors.primary : AppColors.textSecondary,
              size: 20,
            ),
          ),
          IconButton(
            onPressed: onDelete,
            icon: const Icon(
              Icons.delete_outline,
              color: AppColors.danger,
              size: 20,
            ),
          ),
          PopupMenuButton<String>(
            icon: const Icon(Icons.more_vert, color: AppColors.textSecondary),
            color: theme.cardColor,
            onSelected: (value) {
              if (value == 'edit') onTapEdit();
              if (value == 'delete') onDelete();
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                value: 'edit', 
                child: Text('Edit', style: TextStyle(color: theme.textTheme.bodyMedium?.color))
              ),
              PopupMenuItem(
                value: 'delete', 
                child: Text('Delete', style: TextStyle(color: theme.textTheme.bodyMedium?.color))
              ),
            ],
          ),
        ],
      ),
    );
  }
}
