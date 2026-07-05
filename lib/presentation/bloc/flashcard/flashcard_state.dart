import 'package:equatable/equatable.dart';
import '../../../data/models/category_model.dart';
import '../../../data/models/flashcard_model.dart';
import '../../../data/models/notification_model.dart';

enum FlashcardStatus { initial, loading, loaded, failure }

/// Single immutable state for [FlashcardBloc].
///
/// Rather than splitting into many state subclasses, this app uses one
/// state object with derived getters (totalCards, studiedCount, etc).
/// This keeps every screen's BlocBuilder trivial: just read a getter.
class FlashcardState extends Equatable {
  final FlashcardStatus status;
  final List<CategoryModel> categories;
  final List<FlashcardModel> flashcards;
  final List<NotificationModel> notifications;
  final String searchQuery;
  final String? errorMessage;

  const FlashcardState({
    this.status = FlashcardStatus.initial,
    this.categories = const [],
    this.flashcards = const [],
    this.notifications = const [],
    this.searchQuery = '',
    this.errorMessage,
  });

  int get totalCards => flashcards.length;

  int get totalCategories => categories.length;

  int get studiedCount => flashcards.where((f) => f.hasBeenStudied).length;

  List<FlashcardModel> get bookmarkedFlashcards => flashcards.where((f) => f.isBookmarked).toList();

  /// Most-recently studied cards first.
  List<FlashcardModel> get recentlyStudied {
    final studied = flashcards.where((f) => f.lastStudiedAt != null).toList()
      ..sort((a, b) => b.lastStudiedAt!.compareTo(a.lastStudiedAt!));
    return studied;
  }

  List<FlashcardModel> get searchResults {
    final query = searchQuery.trim().toLowerCase();
    if (query.isEmpty) return const [];
    return flashcards.where((f) => f.question.toLowerCase().contains(query)).toList();
  }

  List<FlashcardModel> flashcardsByCategory(String categoryId) =>
      flashcards.where((f) => f.categoryId == categoryId).toList();

  int cardCountForCategory(String categoryId) => flashcards.where((f) => f.categoryId == categoryId).length;

  CategoryModel? categoryById(String categoryId) {
    for (final category in categories) {
      if (category.id == categoryId) return category;
    }
    return null;
  }

  FlashcardState copyWith({
    FlashcardStatus? status,
    List<CategoryModel>? categories,
    List<FlashcardModel>? flashcards,
    List<NotificationModel>? notifications,
    String? searchQuery,
    String? errorMessage,
  }) {
    return FlashcardState(
      status: status ?? this.status,
      categories: categories ?? this.categories,
      flashcards: flashcards ?? this.flashcards,
      notifications: notifications ?? this.notifications,
      searchQuery: searchQuery ?? this.searchQuery,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, categories, flashcards, notifications, searchQuery, errorMessage];
}
