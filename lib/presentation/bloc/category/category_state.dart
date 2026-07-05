import 'package:equatable/equatable.dart';
import '../../../domain/entities/category.dart';
import '../../../domain/entities/flashcard.dart';

abstract class CategoryState extends Equatable {
  const CategoryState();

  @override
  List<Object?> get props => [];
}

class CategoryInitial extends CategoryState {}

class CategoryLoading extends CategoryState {}

class CategoryLoaded extends CategoryState {
  final List<Category> categories;
  final int totalCardsCount;
  final int studiedCardsCount;
  final Flashcard? recentFlashcard;

  const CategoryLoaded({
    required this.categories,
    required this.totalCardsCount,
    required this.studiedCardsCount,
    this.recentFlashcard,
  });

  @override
  List<Object?> get props => [categories, totalCardsCount, studiedCardsCount, recentFlashcard];
}

class CategoryError extends CategoryState {
  final String message;

  const CategoryError(this.message);

  @override
  List<Object?> get props => [message];
}
