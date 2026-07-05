import 'package:flutter/material.dart';
import '../../domain/entities/category.dart';
import '../pages/quiz_page.dart';

class CategoryCard extends StatelessWidget {
  final Category category;

  const CategoryCard({super.key, required this.category});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => QuizPage(
              categoryId: category.id,
              categoryName: category.name,
            ),
          ),
        );
      },
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(_getIconData(category.icon), size: 48, color: Theme.of(context).primaryColor),
              const SizedBox(height: 12),
              Text(
                category.name,
                style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 8),
              Text(
                '${category.totalCards} cards',
                style: const TextStyle(fontSize: 14, color: Colors.grey),
              ),
              const SizedBox(height: 8),
              LinearProgressIndicator(
                value: category.totalCards > 0 ? category.studiedCards / category.totalCards : 0,
                backgroundColor: Colors.grey[200],
                valueColor: AlwaysStoppedAnimation<Color>(Theme.of(context).primaryColor),
              ),
            ],
          ),
        ),
      ),
    );
  }

  IconData _getIconData(String iconName) {
    switch (iconName) {
      case 'code': return Icons.code;
      case 'science': return Icons.science_outlined;
      case 'calculate': return Icons.calculate_outlined;
      case 'lightbulb': return Icons.lightbulb_outline;
      case 'storage': return Icons.storage;
      default: return Icons.category_outlined;
    }
  }
}
