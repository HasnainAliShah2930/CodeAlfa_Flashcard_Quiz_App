import 'package:equatable/equatable.dart';

class Category extends Equatable {
  final String id;
  final String name;
  final String icon;
  final int totalCards;
  final int studiedCards;
  final int learningCards;

  const Category({
    required this.id,
    required this.name,
    required this.icon,
    required this.totalCards,
    this.studiedCards = 0,
    this.learningCards = 0,
  });

  int get yetToLearn => totalCards - studiedCards - learningCards;

  @override
  List<Object?> get props => [id, name, icon, totalCards, studiedCards, learningCards];
}
