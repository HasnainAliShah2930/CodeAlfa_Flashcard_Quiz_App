import 'package:equatable/equatable.dart';

abstract class QuizEvent extends Equatable {
  const QuizEvent();

  @override
  List<Object?> get props => [];
}

class LoadQuiz extends QuizEvent {
  final String categoryId;
  const LoadQuiz(this.categoryId);

  @override
  List<Object?> get props => [categoryId];
}

class FlipCard extends QuizEvent {}

class NextCard extends QuizEvent {}

class PreviousCard extends QuizEvent {}

class MarkStudied extends QuizEvent {
  final String flashcardId;
  const MarkStudied(this.flashcardId);

  @override
  List<Object?> get props => [flashcardId];
}

class QuizRestarted extends QuizEvent {}
