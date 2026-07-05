import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/bloc/settings/settings_bloc.dart';
import '../../presentation/bloc/settings/settings_state.dart';
import '../localization/app_localizations.dart';
import '../constants/app_colors.dart';
import '../constants/app_text_styles.dart';
import 'confirm_action_dialog.dart';

class _DrawerItem {
  final IconData icon;
  final String labelKey;
  final String route;
  const _DrawerItem(this.icon, this.labelKey, this.route);
}

class AppDrawer extends StatelessWidget {
  final String currentRoute;

  const AppDrawer({super.key, required this.currentRoute});

  static const _items = [
    _DrawerItem(Icons.home_outlined, 'home', '/home'),
    _DrawerItem(Icons.style_outlined, 'my_flashcards', '/my-flashcards'),
    _DrawerItem(Icons.grid_view_outlined, 'categories', '/categories'),
    _DrawerItem(Icons.menu_book_outlined, 'study', '/study'),
    _DrawerItem(Icons.bookmark_border, 'bookmarks', '/bookmarks'),
    _DrawerItem(Icons.bar_chart_outlined, 'statistics', '/statistics'),
  ];

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final code = state.languageCode;
        
        return Drawer(
          backgroundColor: AppColors.primary,
          width: 280,
          child: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Padding(
                  padding: EdgeInsets.fromLTRB(20, 12, 20, 24),
                  child: _DrawerHeader(),
                ),
                Expanded(
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Theme.of(context).scaffoldBackgroundColor,
                      borderRadius: const BorderRadius.only(topLeft: Radius.circular(28)),
                    ),
                    child: ListView(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      children: [
                        for (final item in _items)
                          _DrawerTile(
                            icon: item.icon,
                            label: AppTranslations.getString(code, item.labelKey),
                            selected: currentRoute == item.route,
                            onTap: () {
                              Navigator.of(context).pop();
                              if (currentRoute != item.route) {
                                if (item.route == '/home') {
                                  context.go(item.route);
                                } else {
                                  context.push(item.route);
                                }
                              }
                            },
                          ),
                        const Divider(height: 32, color: AppColors.border),
                        _DrawerTile(
                          icon: Icons.settings_outlined,
                          label: AppTranslations.getString(code, 'settings'),
                          selected: currentRoute == '/settings',
                          onTap: () {
                            Navigator.of(context).pop();
                            if (currentRoute != '/settings') context.push('/settings');
                          },
                        ),
                        _DrawerTile(
                          icon: Icons.help_outline,
                          label: AppTranslations.getString(code, 'help'),
                          selected: currentRoute == '/help',
                          onTap: () {
                            Navigator.of(context).pop();
                            if (currentRoute != '/help') context.push('/help');
                          },
                        ),
                        _DrawerTile(
                          icon: Icons.logout,
                          label: AppTranslations.getString(code, 'logout'),
                          selected: false,
                          isDestructive: true,
                          onTap: () {
                            Navigator.of(context).pop();
                            showDialog(
                              context: context,
                              builder: (_) => ConfirmActionDialog(
                                icon: Icons.logout,
                                title: AppTranslations.getString(code, 'logout'),
                                message: 'Are you sure you want to logout?',
                                confirmLabel: AppTranslations.getString(code, 'logout'),
                                onConfirm: () => context.go('/'),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _DrawerHeader extends StatelessWidget {
  const _DrawerHeader();

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        return Row(
          children: [
            CircleAvatar(
              radius: 24,
              backgroundColor: Colors.white24,
              backgroundImage: state.profileImagePath != null 
                  ? FileImage(File(state.profileImagePath!)) as ImageProvider
                  : null,
              child: state.profileImagePath == null 
                  ? const Icon(Icons.person, color: Colors.white) 
                  : null,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(state.userName, style: AppTextStyles.heading3.copyWith(color: Colors.white)),
                Text('Keep learning!', style: AppTextStyles.bodySecondary.copyWith(color: Colors.white70)),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _DrawerTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool selected;
  final bool isDestructive;
  final VoidCallback onTap;

  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
    this.isDestructive = false,
  });

  @override
  Widget build(BuildContext context) {
    final color = isDestructive ? AppColors.danger : (selected ? AppColors.primary : AppColors.textSecondary);
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 2),
      decoration: BoxDecoration(
        color: selected ? AppColors.primary.withValues(alpha: 0.08) : Colors.transparent,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: color, size: 20),
        title: Text(
          label,
          style: AppTextStyles.body.copyWith(
            color: isDestructive ? AppColors.danger : Theme.of(context).textTheme.bodyMedium?.color,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
        onTap: onTap,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }
}
