import 'package:flutter/material.dart';
import '../constants/app_text_styles.dart';

class StatCard extends StatelessWidget {
  final String value;
  final String label;
  final Color backgroundColor;
  final Color valueColor;

  const StatCard({
    super.key,
    required this.value,
    required this.label,
    required this.backgroundColor,
    required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final themeText = Theme.of(context).textTheme;
    
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: isDark ? backgroundColor.withValues(alpha: 0.1) : backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            value, 
            style: AppTextStyles.heading2.copyWith(color: valueColor)
          ),
          const SizedBox(height: 4),
          Text(
            label, 
            style: AppTextStyles.caption.copyWith(
              color: isDark ? Colors.white70 : themeText.bodySmall?.color,
            ), 
            textAlign: TextAlign.center
          ),
        ],
      ),
    );
  }
}
