import 'package:equatable/equatable.dart';
import '../../../data/models/flashcard_model.dart';

abstract class QuizState extends Equatable {
  const QuizState();

  @override
  List<Object?> get props => [];
}

class QuizInitial extends QuizState {}

class QuizLoading extends QuizState {}

class QuizLoaded extends QuizState {
  final List<FlashcardModel> flashcards;
  final int currentIndex;
  final bool isFlipped;
  final int correctCount;

  const QuizLoaded({
    required this.flashcards,
    this.currentIndex = 0,
    this.isFlipped = false,
    this.correctCount = 0,
  });

  FlashcardModel get currentCard => flashcards[currentIndex];

  @override
  List<Object?> get props => [flashcards, currentIndex, isFlipped, correctCount];

  QuizLoaded copyWith({
    List<FlashcardModel>? flashcards,
    int? currentIndex,
    bool? isFlipped,
    int? correctCount,
  }) {
    return QuizLoaded(
      flashcards: flashcards ?? this.flashcards,
      currentIndex: currentIndex ?? this.currentIndex,
      isFlipped: isFlipped ?? this.isFlipped,
      correctCount: correctCount ?? this.correctCount,
    );
  }
}

class QuizFinished extends QuizState {
  final int correctCount;
  final int totalCount;

  const QuizFinished({required this.correctCount, required this.totalCount});

  @override
  List<Object?> get props => [correctCount, totalCount];
}

class QuizError extends QuizState {
  final String message;

  const QuizError(this.message);

  @override
  List<Object?> get props => [message];
}
