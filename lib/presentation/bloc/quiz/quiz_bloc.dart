import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/repositories/flashcard_repository.dart';
import 'quiz_event.dart';
import 'quiz_state.dart';

class QuizBloc extends Bloc<QuizEvent, QuizState> {
  final FlashcardRepository repository;

  QuizBloc({required this.repository}) : super(QuizInitial()) {
    on<LoadQuiz>((event, emit) async {
      emit(QuizLoading());
      try {
        final allCards = await repository.getFlashcards();
        final flashcards = allCards.where((f) => f.categoryId == event.categoryId).toList();
        
        if (flashcards.isEmpty) {
          emit(const QuizError("No flashcards found in this category"));
        } else {
          emit(QuizLoaded(flashcards: flashcards));
        }
      } catch (e) {
        emit(const QuizError("Failed to load flashcards"));
      }
    });

    on<FlipCard>((event, emit) {
      if (state is QuizLoaded) {
        final currentState = state as QuizLoaded;
        emit(currentState.copyWith(isFlipped: !currentState.isFlipped));
      }
    });

    on<NextCard>((event, emit) {
      if (state is QuizLoaded) {
        final currentState = state as QuizLoaded;
        if (currentState.currentIndex < currentState.flashcards.length - 1) {
          emit(currentState.copyWith(
            currentIndex: currentState.currentIndex + 1,
            isFlipped: false,
          ));
        } else {
          emit(QuizFinished(
            correctCount: currentState.correctCount,
            totalCount: currentState.flashcards.length,
          ));
        }
      }
    });

    on<PreviousCard>((event, emit) {
      if (state is QuizLoaded) {
        final currentState = state as QuizLoaded;
        if (currentState.currentIndex > 0) {
          emit(currentState.copyWith(
            currentIndex: currentState.currentIndex - 1,
            isFlipped: false,
          ));
        }
      }
    });

    on<MarkStudied>((event, emit) async {
      if (state is QuizLoaded) {
        final currentState = state as QuizLoaded;
        
        // Find the card and mark it as studied in repository
        final card = currentState.currentCard;
        await repository.updateFlashcard(card.copyWith(
          studyCount: card.studyCount + 1,
          lastStudiedAt: DateTime.now(),
        ));
        
        final newState = currentState.copyWith(
          correctCount: currentState.correctCount + 1,
        );
        
        if (newState.currentIndex < newState.flashcards.length - 1) {
          emit(newState.copyWith(
            currentIndex: newState.currentIndex + 1,
            isFlipped: false,
          ));
        } else {
          emit(QuizFinished(
            correctCount: newState.correctCount,
            totalCount: newState.flashcards.length,
          ));
        }
      }
    });

    on<QuizRestarted>((event, emit) {
      if (state is QuizFinished) {
        // This is a bit tricky since we don't have the cards anymore in QuizFinished
        // But QuizPage handles pop and study again differently.
        // For simplicity, emit initial or wait for LoadQuiz
        emit(QuizInitial());
      }
    });
  }
}
