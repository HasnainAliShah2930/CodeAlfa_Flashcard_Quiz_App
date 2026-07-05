import 'package:flutter/material.dart';

/// Domain model representing a flashcard category (e.g. "Programming").
///
/// This is a plain, immutable OOP entity used across every layer of the
/// app (repository -> BLoC -> UI). It carries its own display metadata
/// (icon + color) so widgets never need to branch on category name.
class CategoryModel {
  final String id;
  final String name;
  final IconData icon;
  final Color color;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.icon,
    required this.color,
  });

  CategoryModel copyWith({
    String? id,
    String? name,
    IconData? icon,
    Color? color,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      icon: icon ?? this.icon,
      color: color ?? this.color,
    );
  }

  @override
  bool operator ==(Object other) => other is CategoryModel && other.id == id;

  @override
  int get hashCode => id.hashCode;

  @override
  String toString() => 'CategoryModel(id: $id, name: $name)';
}
