import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/repositories/quiz_repository.dart';
import 'category_event.dart';
import 'category_state.dart';

class CategoryBloc extends Bloc<CategoryEvent, CategoryState> {
  final QuizRepository repository;

  CategoryBloc(this.repository) : super(CategoryInitial()) {
    on<LoadCategories>((event, emit) async {
      emit(CategoryLoading());
      try {
        final categories = await repository.getCategories();
        final allCards = await repository.getAllFlashcards();
        final recent = await repository.getRecentlyStudied();
        
        final totalCardsCount = allCards.length;
        final studiedCardsCount = allCards.where((c) => c.isStudied).length;
        
        emit(CategoryLoaded(
          categories: categories,
          totalCardsCount: totalCardsCount,
          studiedCardsCount: studiedCardsCount,
          recentFlashcard: recent.isNotEmpty ? recent.first : null,
        ));
      } catch (e) {
        emit(const CategoryError("Failed to load categories"));
      }
    });
  }
}
