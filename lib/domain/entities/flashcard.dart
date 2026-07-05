import 'package:equatable/equatable.dart';

class Flashcard extends Equatable {
  final String id;
  final String question;
  final String answer;
  final String categoryId;
  final bool isStudied;
  final bool isBookmarked;
  final DateTime? lastStudied;

  const Flashcard({
    required this.id,
    required this.question,
    required this.answer,
    required this.categoryId,
    this.isStudied = false,
    this.isBookmarked = false,
    this.lastStudied,
  });

  @override
  List<Object?> get props => [id, question, answer, categoryId, isStudied, isBookmarked, lastStudied];

  Flashcard copyWith({
    String? id,
    String? question,
    String? answer,
    String? categoryId,
    bool? isStudied,
    bool? isBookmarked,
    DateTime? lastStudied,
  }) {
    return Flashcard(
      id: id ?? this.id,
      question: question ?? this.question,
      answer: answer ?? this.answer,
      categoryId: categoryId ?? this.categoryId,
      isStudied: isStudied ?? this.isStudied,
      isBookmarked: isBookmarked ?? this.isBookmarked,
      lastStudied: lastStudied ?? this.lastStudied,
    );
  }
}
