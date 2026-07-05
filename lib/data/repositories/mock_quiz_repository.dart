import '../../domain/entities/category.dart';
import '../../domain/entities/flashcard.dart';
import '../../domain/repositories/quiz_repository.dart';

class MockQuizRepository implements QuizRepository {
  final List<Flashcard> _flashcards = [];
  
  final List<Category> _categories = [
    const Category(id: '1', name: 'Programming', icon: 'code', totalCards: 0, studiedCards: 0, learningCards: 0),
    const Category(id: '2', name: 'Science', icon: 'science', totalCards: 0, studiedCards: 0, learningCards: 0),
    const Category(id: '3', name: 'Math', icon: 'calculate', totalCards: 0, studiedCards: 0, learningCards: 0),
    const Category(id: '4', name: 'General Knowledge', icon: 'lightbulb', totalCards: 0, studiedCards: 0, learningCards: 0),
    const Category(id: '5', name: 'Database', icon: 'storage', totalCards: 0, studiedCards: 0, learningCards: 0),
  ];

  @override
  Future<List<Category>> getCategories() async {
    // We calculate the counts based on the current flashcards
    return _categories.map((cat) {
      final catCards = _flashcards.where((f) => f.categoryId == cat.id).toList();
      final studied = catCards.where((f) => f.isStudied).length;
      return Category(
        id: cat.id,
        name: cat.name,
        icon: cat.icon,
        totalCards: catCards.length,
        studiedCards: studied,
        learningCards: 0, // Simplified for now
      );
    }).toList();
  }

  @override
  Future<List<Flashcard>> getFlashcardsByCategory(String categoryId) async {
    return _flashcards.where((f) => f.categoryId == categoryId).toList();
  }

  @override
  Future<void> markAsStudied(String flashcardId) async {
    final index = _flashcards.indexWhere((f) => f.id == flashcardId);
    if (index != -1) {
      _flashcards[index] = _flashcards[index].copyWith(
        isStudied: true,
        lastStudied: DateTime.now(),
      );
    }
  }

  @override
  Future<void> addFlashcard(Flashcard flashcard) async {
    _flashcards.add(flashcard);
  }

  @override
  Future<List<Flashcard>> getAllFlashcards() async {
    return _flashcards;
  }

  @override
  Future<List<Flashcard>> getRecentlyStudied() async {
    final studied = _flashcards.where((f) => f.lastStudied != null).toList();
    studied.sort((a, b) => b.lastStudied!.compareTo(a.lastStudied!));
    return studied;
  }
}
