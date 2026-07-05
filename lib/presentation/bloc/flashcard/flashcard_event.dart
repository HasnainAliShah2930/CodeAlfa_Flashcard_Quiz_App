import 'package:equatable/equatable.dart';
import '../../../data/models/flashcard_model.dart';

abstract class FlashcardEvent extends Equatable {
  const FlashcardEvent();

  @override
  List<Object?> get props => [];
}

/// Loads categories + flashcards from the repository.
class FlashcardsLoadRequested extends FlashcardEvent {}

class FlashcardAddRequested extends FlashcardEvent {
  final FlashcardModel flashcard;
  const FlashcardAddRequested(this.flashcard);

  @override
  List<Object?> get props => [flashcard];
}

class FlashcardUpdateRequested extends FlashcardEvent {
  final FlashcardModel flashcard;
  const FlashcardUpdateRequested(this.flashcard);

  @override
  List<Object?> get props => [flashcard];
}

class FlashcardDeleteRequested extends FlashcardEvent {
  final String flashcardId;
  const FlashcardDeleteRequested(this.flashcardId);

  @override
  List<Object?> get props => [flashcardId];
}

class FlashcardBookmarkToggled extends FlashcardEvent {
  final String flashcardId;
  const FlashcardBookmarkToggled(this.flashcardId);

  @override
  List<Object?> get props => [flashcardId];
}

/// Increments study count + stamps lastStudiedAt for a card.
class FlashcardStudiedMarked extends FlashcardEvent {
  final String flashcardId;
  const FlashcardStudiedMarked(this.flashcardId);

  @override
  List<Object?> get props => [flashcardId];
}

class FlashcardSearchQueryChanged extends FlashcardEvent {
  final String query;
  const FlashcardSearchQueryChanged(this.query);

  @override
  List<Object?> get props => [query];
}
