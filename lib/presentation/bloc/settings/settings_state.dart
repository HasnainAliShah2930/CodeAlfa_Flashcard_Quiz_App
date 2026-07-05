import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;
  final String languageCode;
  final String userName;
  final String? profileImagePath;

  const SettingsState({
    this.themeMode = ThemeMode.light,
    this.languageCode = 'en',
    this.userName = 'Hasnain Ali',
    this.profileImagePath,
  });

  SettingsState copyWith({
    ThemeMode? themeMode,
    String? languageCode,
    String? userName,
    String? profileImagePath,
  }) {
    return SettingsState(
      themeMode: themeMode ?? this.themeMode,
      languageCode: languageCode ?? this.languageCode,
      userName: userName ?? this.userName,
      profileImagePath: profileImagePath ?? this.profileImagePath,
    );
  }

  @override
  List<Object?> get props => [themeMode, languageCode, userName, profileImagePath];
}
