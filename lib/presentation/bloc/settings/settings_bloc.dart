import 'package:flutter_bloc/flutter_bloc.dart';
import 'settings_event.dart';
import 'settings_state.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  SettingsBloc() : super(const SettingsState()) {
    on<ThemeChanged>((event, emit) {
      emit(state.copyWith(themeMode: event.themeMode));
    });
    on<LanguageChanged>((event, emit) {
      emit(state.copyWith(languageCode: event.languageCode));
    });
    on<UserNameChanged>((event, emit) {
      emit(state.copyWith(userName: event.userName));
    });
    on<ProfileImageChanged>((event, emit) {
      emit(state.copyWith(profileImagePath: event.profileImagePath));
    });
  }
}
