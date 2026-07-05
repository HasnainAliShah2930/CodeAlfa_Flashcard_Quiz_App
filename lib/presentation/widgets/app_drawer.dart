import 'package:flutter/material.dart';
import 'package:flashcard_quiz_app/presentation/pages/home_page.dart';
import 'package:flashcard_quiz_app/presentation/pages/my_flashcards_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.only(top: 60, left: 24, bottom: 24, right: 24),
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF6A4BC1), Color(0xFF4A3298)],
              ),
            ),
            child: Row(
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage('https://i.pravatar.cc/150?u=hasnain'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Hasnain Ali',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Keep learning!',
                      style: TextStyle(
                        color: Colors.white70,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(vertical: 16),
              children: [
                _buildMenuItem(context, Icons.home_outlined, 'Home', true, onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const HomePage()));
                }),
                _buildMenuItem(context, Icons.collections_bookmark_outlined, 'My Flashcards', false, onTap: () {
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const MyFlashcardsPage()));
                }),
                _buildMenuItem(context, Icons.grid_view_outlined, 'Categories', false),
                _buildMenuItem(context, Icons.play_circle_outline, 'Study', false),
                _buildMenuItem(context, Icons.bookmark_border, 'Bookmarks', false),
                _buildMenuItem(context, Icons.bar_chart_outlined, 'Statistics', false),
                const Divider(),
                _buildMenuItem(context, Icons.settings_outlined, 'Settings', false),
                _buildMenuItem(context, Icons.help_outline, 'Help & Support', false),
                const SizedBox(height: 20),
                _buildMenuItem(context, Icons.logout, 'Logout', false, color: Colors.red),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMenuItem(BuildContext context, IconData icon, String title, bool isSelected, {Color? color, VoidCallback? onTap}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? const Color(0xFFF5F3FF) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: color ?? (isSelected ? const Color(0xFF6A4BC1) : Colors.grey[700])),
        title: Text(
          title,
          style: TextStyle(
            color: color ?? (isSelected ? const Color(0xFF6A4BC1) : Colors.black87),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
          ),
        ),
        onTap: onTap ?? () {
          Navigator.pop(context);
        },
      ),
    );
  }
}
