import '../entities/category.dart';
import '../entities/flashcard.dart';

abstract class QuizRepository {
  Future<List<Category>> getCategories();
  Future<List<Flashcard>> getFlashcardsByCategory(String categoryId);
  Future<void> markAsStudied(String flashcardId);
  Future<void> addFlashcard(Flashcard flashcard);
  Future<List<Flashcard>> getAllFlashcards();
  Future<List<Flashcard>> getRecentlyStudied();
}
