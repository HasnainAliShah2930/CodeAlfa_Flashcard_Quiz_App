import 'package:flutter/material.dart';
import '../../data/models/category_model.dart';
import '../constants/app_text_styles.dart';

class CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final int cardCount;
  final VoidCallback onTap;
  final Widget? trailing;

  const CategoryCard({
    super.key,
    required this.category,
    required this.cardCount,
    required this.onTap,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: Theme.of(context).dividerColor.withValues(alpha: 0.1)),
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: category.color.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(category.icon, color: category.color, size: 20),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name, 
                    style: AppTextStyles.body.copyWith(
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).textTheme.bodyLarge?.color,
                    )
                  ),
                  Text(
                    '$cardCount Cards', 
                    style: AppTextStyles.caption.copyWith(
                      color: Theme.of(context).textTheme.bodySmall?.color,
                    )
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing!,
          ],
        ),
      ),
    );
  }
}
