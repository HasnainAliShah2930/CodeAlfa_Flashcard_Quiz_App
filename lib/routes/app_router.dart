import 'package:go_router/go_router.dart';
import '../presentation/screens/categories/categories_screen.dart';
import '../presentation/screens/flashcard_form/flashcard_form_screen.dart';
import '../presentation/screens/flashcard_list/bookmarks_screen.dart';
import '../presentation/screens/flashcard_list/flashcard_list_screen.dart';
import '../presentation/screens/home/home_screen.dart';
import '../presentation/screens/my_flashcards/my_flashcards_screen.dart';
import '../presentation/screens/quiz/quiz_screen.dart';
import '../presentation/screens/splash/splash_screen.dart';
import '../presentation/screens/statistics/statistics_screen.dart';
import '../presentation/screens/help/help_support_screen.dart';
import '../presentation/screens/settings/settings_screen.dart';

/// Centralized route table. All navigation goes through go_router so deep
/// links and route names stay consistent across the app.
class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(path: '/', builder: (context, state) => const SplashScreen()),
      GoRoute(path: '/home', builder: (context, state) => const HomeScreen()),
      GoRoute(path: '/categories', builder: (context, state) => const CategoriesScreen()),
      GoRoute(path: '/my-flashcards', builder: (context, state) => const MyFlashcardsScreen()),
      GoRoute(path: '/bookmarks', builder: (context, state) => const BookmarksScreen()),
      GoRoute(path: '/statistics', builder: (context, state) => const StatisticsScreen()),
      GoRoute(path: '/help', builder: (context, state) => const HelpSupportScreen()),
      GoRoute(path: '/settings', builder: (context, state) => const SettingsScreen()),
      GoRoute(
        path: '/category/:categoryId',
        builder: (context, state) => QuizScreen(categoryId: state.pathParameters['categoryId']!),
      ),
      GoRoute(
        path: '/category/:categoryId/list',
        builder: (context, state) => FlashcardListScreen(categoryId: state.pathParameters['categoryId']!),
      ),
      GoRoute(
        path: '/study',
        redirect: (context, state) => '/categories',
      ),
      GoRoute(
        path: '/flashcard/add',
        builder: (context, state) => FlashcardFormScreen(
          initialCategoryId: state.uri.queryParameters['categoryId'],
        ),
      ),
      GoRoute(
        path: '/flashcard/edit/:flashcardId',
        builder: (context, state) =>
            FlashcardFormScreen(editingFlashcardId: state.pathParameters['flashcardId']!),
      ),
    ],
  );
}
