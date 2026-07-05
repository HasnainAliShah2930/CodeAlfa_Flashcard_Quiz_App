import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flashcard_quiz_app/presentation/bloc/category/category_bloc.dart';
import 'package:flashcard_quiz_app/presentation/bloc/category/category_state.dart';
import 'package:flashcard_quiz_app/presentation/bloc/category/category_event.dart';
import 'package:flashcard_quiz_app/presentation/widgets/app_drawer.dart';
import 'package:flashcard_quiz_app/presentation/pages/add_flashcard_page.dart';
import 'package:flashcard_quiz_app/presentation/pages/quiz_page.dart';
import 'package:flashcard_quiz_app/routes/injection_container.dart';
import 'package:intl/intl.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<CategoryBloc>()..add(LoadCategories()),
      child: Scaffold(
        backgroundColor: Colors.white,
        drawer: const AppDrawer(),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Builder(
            builder: (context) => IconButton(
              icon: const Icon(Icons.menu, color: Colors.black),
              onPressed: () => Scaffold.of(context).openDrawer(),
            ),
          ),
          title: const Text(
            'Flashcard Quiz',
            style: TextStyle(
              color: Color(0xFF6A4BC1),
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          actions: [
            IconButton(
              icon: const Icon(Icons.notifications_none, color: Colors.black),
              onPressed: () {},
            ),
          ],
        ),
        body: BlocBuilder<CategoryBloc, CategoryState>(
          builder: (context, state) {
            if (state is CategoryLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is CategoryLoaded) {
              return SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    const Text(
                      'Hello, Hasnain! 👋',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Text(
                      'Keep learning, keep growing.',
                      style: TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        _buildStatCard(state.totalCardsCount.toString(), 'Total Cards', const Color(0xFFF5F3FF), const Color(0xFF6A4BC1)),
                        const SizedBox(width: 12),
                        _buildStatCard(state.categories.where((c) => c.totalCards > 0).length.toString(), 'Categories', const Color(0xFFF0FDF4), const Color(0xFF22C55E)),
                        const SizedBox(width: 12),
                        _buildStatCard(state.studiedCardsCount.toString(), 'Studied', const Color(0xFFFFF7ED), const Color(0xFFF97316)),
                      ],
                    ),
                    const SizedBox(height: 32),
                    _buildSectionHeader('Categories', context),
                    const SizedBox(height: 16),
                    if (state.categories.every((c) => c.totalCards == 0))
                      const Center(child: Text("No categories with cards yet. Add some!"))
                    else
                      Wrap(
                        spacing: 16,
                        runSpacing: 16,
                        children: state.categories.where((c) => c.totalCards > 0).map((category) {
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
                            child: _buildCategoryItem(
                              category.name,
                              '${category.totalCards} Cards',
                              _getCategoryIcon(category.name),
                              _getCategoryColor(category.name),
                            ),
                          );
                        }).toList(),
                      ),
                    const SizedBox(height: 32),
                    _buildSectionHeader('Recently Studied', context),
                    const SizedBox(height: 16),
                    if (state.recentFlashcard == null)
                      const Center(child: Text("No cards studied yet."))
                    else
                      _buildRecentItem(
                        state.recentFlashcard!.question,
                        'Last studied: ${DateFormat('h:mm a').format(state.recentFlashcard!.lastStudied!)}',
                        state.categories.firstWhere((c) => c.id == state.recentFlashcard!.categoryId).totalCards.toString(),
                        const Color(0xFFF5F3FF),
                        const Color(0xFF6A4BC1),
                      ),
                    const SizedBox(height: 24),
                    SizedBox(
                      width: double.infinity,
                      height: 56,
                      child: ElevatedButton.icon(
                        onPressed: () async {
                          await Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => const AddFlashcardPage()),
                          );
                          if (context.mounted) {
                            context.read<CategoryBloc>().add(LoadCategories());
                          }
                        },
                        icon: const Icon(Icons.add, color: Colors.white),
                        label: const Text(
                          'Add New Flashcard',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6A4BC1),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          elevation: 0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                  ],
                ),
              );
            } else if (state is CategoryError) {
              return Center(child: Text(state.message));
            }
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildStatCard(String value, String label, Color bgColor, Color textColor) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: textColor),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(fontSize: 12, color: textColor.withValues(alpha: 0.7)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        TextButton(
          onPressed: () {},
          child: const Text('View All', style: TextStyle(color: Color(0xFF6A4BC1))),
        ),
      ],
    );
  }

  Widget _buildCategoryItem(String title, String subtitle, IconData icon, Color color) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 8),
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  subtitle,
                  style: const TextStyle(color: Colors.grey, fontSize: 11),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRecentItem(String title, String time, String count, Color bgColor, Color iconColor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8F9FB),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.code, color: iconColor),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  time,
                  style: const TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFE5E7EB),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              count,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }

  IconData _getCategoryIcon(String name) {
    if (name.contains('Programming')) return Icons.code;
    if (name.contains('Science')) return Icons.science_outlined;
    if (name.contains('Math')) return Icons.calculate_outlined;
    if (name.contains('General')) return Icons.lightbulb_outline;
    if (name.contains('Database')) return Icons.storage;
    return Icons.category_outlined;
  }

  Color _getCategoryColor(String name) {
    if (name.contains('Programming')) return const Color(0xFF6A4BC1);
    if (name.contains('Science')) return const Color(0xFF22C55E);
    if (name.contains('Math')) return const Color(0xFFF97316);
    if (name.contains('General')) return const Color(0xFFFFB800);
    if (name.contains('Database')) return const Color(0xFF3B82F6);
    return Colors.blue;
  }
}
