import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

abstract class SettingsEvent extends Equatable {
  const SettingsEvent();

  @override
  List<Object?> get props => [];
}

class ThemeChanged extends SettingsEvent {
  final ThemeMode themeMode;
  const ThemeChanged(this.themeMode);

  @override
  List<Object?> get props => [themeMode];
}

class LanguageChanged extends SettingsEvent {
  final String languageCode;
  const LanguageChanged(this.languageCode);

  @override
  List<Object?> get props => [languageCode];
}

class UserNameChanged extends SettingsEvent {
  final String userName;
  const UserNameChanged(this.userName);

  @override
  List<Object?> get props => [userName];
}

class ProfileImageChanged extends SettingsEvent {
  final String? profileImagePath;
  const ProfileImageChanged(this.profileImagePath);

  @override
  List<Object?> get props => [profileImagePath];
}
