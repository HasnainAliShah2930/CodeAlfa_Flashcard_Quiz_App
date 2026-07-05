import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:uuid/uuid.dart';
import '../../../data/models/notification_model.dart';
import '../../../data/repositories/flashcard_repository.dart';
import 'flashcard_event.dart';
import 'flashcard_state.dart';

/// The "ViewModel" for everything flashcard/category related.
///
/// Every screen that needs flashcard data (Home, My Flashcards,
/// Categories, Quiz, Statistics, Flashcard Form) reads from this single
/// app-wide bloc, so there is exactly one source of truth.
class FlashcardBloc extends Bloc<FlashcardEvent, FlashcardState> {
  final FlashcardRepository repository;

  FlashcardBloc({required this.repository}) : super(const FlashcardState()) {
    on<FlashcardsLoadRequested>(_onLoadRequested);
    on<FlashcardAddRequested>(_onAddRequested);
    on<FlashcardUpdateRequested>(_onUpdateRequested);
    on<FlashcardDeleteRequested>(_onDeleteRequested);
    on<FlashcardBookmarkToggled>(_onBookmarkToggled);
    on<FlashcardStudiedMarked>(_onStudiedMarked);
    on<FlashcardSearchQueryChanged>(_onSearchQueryChanged);
  }

  Future<void> _onLoadRequested(FlashcardsLoadRequested event, Emitter<FlashcardState> emit) async {
    emit(state.copyWith(status: FlashcardStatus.loading));
    try {
      final categories = await repository.getCategories();
      final flashcards = await repository.getFlashcards();
      emit(state.copyWith(
        status: FlashcardStatus.loaded,
        categories: categories,
        flashcards: flashcards,
      ));
    } catch (e) {
      emit(state.copyWith(status: FlashcardStatus.failure, errorMessage: e.toString()));
    }
  }

  Future<void> _onAddRequested(FlashcardAddRequested event, Emitter<FlashcardState> emit) async {
    final created = await repository.addFlashcard(event.flashcard);
    final notification = NotificationModel(
      id: const Uuid().v4(),
      message: 'New flashcard added successfully!',
      timestamp: DateTime.now(),
      type: NotificationType.added,
    );
    emit(state.copyWith(
      flashcards: [...state.flashcards, created],
      notifications: [notification, ...state.notifications],
    ));
  }

  Future<void> _onUpdateRequested(FlashcardUpdateRequested event, Emitter<FlashcardState> emit) async {
    final updated = await repository.updateFlashcard(event.flashcard);
    final updatedList = state.flashcards.map((f) => f.id == updated.id ? updated : f).toList();
    emit(state.copyWith(flashcards: updatedList));
  }

  Future<void> _onDeleteRequested(FlashcardDeleteRequested event, Emitter<FlashcardState> emit) async {
    await repository.deleteFlashcard(event.flashcardId);
    final updatedList = state.flashcards.where((f) => f.id != event.flashcardId).toList();
    final notification = NotificationModel(
      id: const Uuid().v4(),
      message: 'Flashcard deleted.',
      timestamp: DateTime.now(),
      type: NotificationType.deleted,
    );
    emit(state.copyWith(
      flashcards: updatedList,
      notifications: [notification, ...state.notifications],
    ));
  }

  Future<void> _onBookmarkToggled(FlashcardBookmarkToggled event, Emitter<FlashcardState> emit) async {
    final target = state.flashcards.firstWhere((f) => f.id == event.flashcardId);
    final isNowBookmarked = !target.isBookmarked;
    final updated = await repository.updateFlashcard(target.copyWith(isBookmarked: isNowBookmarked));
    final updatedList = state.flashcards.map((f) => f.id == updated.id ? updated : f).toList();
    
    final notification = NotificationModel(
      id: const Uuid().v4(),
      message: isNowBookmarked ? 'Card bookmarked' : 'Bookmark removed',
      timestamp: DateTime.now(),
      type: NotificationType.studied, // Reusing studied for general updates
    );

    emit(state.copyWith(
      flashcards: updatedList,
      notifications: [notification, ...state.notifications],
    ));
  }

  Future<void> _onStudiedMarked(FlashcardStudiedMarked event, Emitter<FlashcardState> emit) async {
    final target = state.flashcards.firstWhere((f) => f.id == event.flashcardId);
    final updated = await repository.updateFlashcard(
      target.copyWith(studyCount: target.studyCount + 1, lastStudiedAt: DateTime.now()),
    );
    final updatedList = state.flashcards.map((f) => f.id == updated.id ? updated : f).toList();
    emit(state.copyWith(flashcards: updatedList));
  }

  void _onSearchQueryChanged(FlashcardSearchQueryChanged event, Emitter<FlashcardState> emit) {
    emit(state.copyWith(searchQuery: event.query));
  }
}
