import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/localization/app_localizations.dart';
import '../../bloc/settings/settings_bloc.dart';
import '../../bloc/settings/settings_event.dart';
import '../../bloc/settings/settings_state.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  late TextEditingController _nameController;
  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final currentState = context.read<SettingsBloc>().state;
    _nameController = TextEditingController(text: currentState.userName);
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final XFile? image = await _picker.pickImage(source: source);
      if (image != null && mounted) {
        context.read<SettingsBloc>().add(ProfileImageChanged(image.path));
      }
    } catch (e) {
      debugPrint('Error picking image: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) {
        final code = state.languageCode;
        
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => Navigator.of(context).pop(),
            ),
            title: Text(AppTranslations.getString(code, 'settings'), style: AppTextStyles.heading3),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              _SectionHeader(title: AppTranslations.getString(code, 'profile')),
              const SizedBox(height: 16),
              Center(
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor: AppColors.primary.withValues(alpha: 0.1),
                      backgroundImage: state.profileImagePath != null 
                          ? FileImage(File(state.profileImagePath!)) as ImageProvider
                          : null,
                      child: state.profileImagePath == null 
                          ? Icon(Icons.person, size: 50, color: AppColors.primary) 
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: GestureDetector(
                        onTap: () => _showProfilePicSelector(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: AppColors.primary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.camera_alt, color: Colors.white, size: 20),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Text(AppTranslations.getString(code, 'user_name'), style: AppTextStyles.body.copyWith(fontWeight: FontWeight.w600)),
              const SizedBox(height: 8),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: AppTranslations.getString(code, 'change_name'),
                ),
                onSubmitted: (value) {
                  if (value.trim().isNotEmpty) {
                    context.read<SettingsBloc>().add(UserNameChanged(value.trim()));
                  }
                },
              ),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: () {
                  if (_nameController.text.trim().isNotEmpty) {
                    context.read<SettingsBloc>().add(UserNameChanged(_nameController.text.trim()));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Name updated successfully!')),
                    );
                  }
                },
                child: Text(AppTranslations.getString(code, 'change_name')),
              ),
              const Divider(height: 48),
              _SectionHeader(title: AppTranslations.getString(code, 'appearance')),
              const SizedBox(height: 12),
              SwitchListTile(
                title: Text(AppTranslations.getString(code, 'dark_mode'), style: AppTextStyles.body),
                value: state.themeMode == ThemeMode.dark,
                activeThumbColor: AppColors.primary,
                onChanged: (isDark) {
                  context.read<SettingsBloc>().add(ThemeChanged(isDark ? ThemeMode.dark : ThemeMode.light));
                },
                secondary: const Icon(Icons.dark_mode_outlined),
              ),
              const Divider(height: 32),
              _SectionHeader(title: AppTranslations.getString(code, 'language')),
              const SizedBox(height: 12),
              _LanguageTile(
                title: 'English',
                code: 'en',
                selected: state.languageCode == 'en',
                onTap: () => context.read<SettingsBloc>().add(const LanguageChanged('en')),
              ),
              _LanguageTile(
                title: 'اردو (Urdu)',
                code: 'ur',
                selected: state.languageCode == 'ur',
                onTap: () => context.read<SettingsBloc>().add(const LanguageChanged('ur')),
              ),
              _LanguageTile(
                title: 'Español (Spanish)',
                code: 'es',
                selected: state.languageCode == 'es',
                onTap: () => context.read<SettingsBloc>().add(const LanguageChanged('es')),
              ),
              _LanguageTile(
                title: 'العربية (Arabic)',
                code: 'ar',
                selected: state.languageCode == 'ar',
                onTap: () => context.read<SettingsBloc>().add(const LanguageChanged('ar')),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showProfilePicSelector(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: const Text('Pick from Gallery'),
                onTap: () {
                  _pickImage(ImageSource.gallery);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: const Text('Take a Photo'),
                onTap: () {
                  _pickImage(ImageSource.camera);
                  Navigator.pop(context);
                },
              ),
              ListTile(
                leading: const Icon(Icons.delete, color: Colors.red),
                title: const Text('Remove Picture'),
                onTap: () {
                  context.read<SettingsBloc>().add(const ProfileImageChanged(null));
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  const _SectionHeader({required this.title});

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: AppTextStyles.heading3.copyWith(color: AppColors.primary, fontSize: 16),
    );
  }
}

class _LanguageTile extends StatelessWidget {
  final String title;
  final String code;
  final bool selected;
  final VoidCallback onTap;

  const _LanguageTile({
    required this.title,
    required this.code,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title, style: AppTextStyles.body),
      trailing: selected ? const Icon(Icons.check_circle, color: AppColors.primary) : null,
      onTap: onTap,
    );
  }
}
