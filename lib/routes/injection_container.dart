import 'package:get_it/get_it.dart';
import 'package:flashcard_quiz_app/data/repositories/flashcard_repository.dart';
import 'package:flashcard_quiz_app/presentation/bloc/flashcard/flashcard_bloc.dart';
import 'package:flashcard_quiz_app/presentation/bloc/quiz/quiz_bloc.dart';

import 'package:flashcard_quiz_app/presentation/bloc/settings/settings_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Repositories
  sl.registerLazySingleton<FlashcardRepository>(() => MockFlashcardRepository());

  // Blocs
  sl.registerFactory(() => FlashcardBloc(repository: sl()));
  sl.registerFactory(() => QuizBloc(repository: sl()));
  sl.registerLazySingleton(() => SettingsBloc());
}
