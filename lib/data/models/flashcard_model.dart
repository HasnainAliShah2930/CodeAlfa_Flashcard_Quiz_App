/// Domain model representing a single flashcard.
///
/// Encapsulates its own study/bookmark state and exposes intent-revealing
/// getters (e.g. [hasBeenStudied]) instead of leaking raw fields for the
/// UI layer to interpret.
class FlashcardModel {
  final String id;
  final String categoryId;
  final String question;
  final String answer;
  final bool isBookmarked;
  final DateTime? lastStudiedAt;
  final int studyCount;

  const FlashcardModel({
    required this.id,
    required this.categoryId,
    required this.question,
    required this.answer,
    this.isBookmarked = false,
    this.lastStudiedAt,
    this.studyCount = 0,
  });

  bool get hasBeenStudied => studyCount > 0;

  FlashcardModel copyWith({
    String? id,
    String? categoryId,
    String? question,
    String? answer,
    bool? isBookmarked,
    DateTime? lastStudiedAt,
    int? studyCount,
  }) {
    return FlashcardModel(
      id: id ?? this.id,
      categoryId: categoryId ?? this.categoryId,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      lastStudiedAt: lastStudiedAt ?? this.lastStudiedAt,
      studyCount: studyCount ?? this.studyCount,
    );
  }

  @override
  bool operator ==(Object other) => other is FlashcardModel && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'FlashcardModel(id: $id, question: $question)';
}
