import 'package:flutter/material.dart';
import '../models/category_model.dart';
import '../models/flashcard_model.dart';

/// Abstract data-access contract for flashcards & categories.
///
/// The presentation layer (BLoCs) only ever depends on this interface,
/// never on a concrete implementation. Swap [MockFlashcardRepository] for
/// a Hive/sqflite/Firestore/REST implementation later without touching
/// any BLoC or UI code.
abstract class FlashcardRepository {
  Future<List<CategoryModel>> getCategories();
  Future<List<FlashcardModel>> getFlashcards();
  Future<FlashcardModel> addFlashcard(FlashcardModel flashcard);
  Future<FlashcardModel> updateFlashcard(FlashcardModel flashcard);
  Future<void> deleteFlashcard(String flashcardId);
}

/// In-memory mock implementation, pre-seeded with realistic sample data
/// so the app is fully usable out of the box.
class MockFlashcardRepository implements FlashcardRepository {
  MockFlashcardRepository() {
    _seed();
  }

  final List<CategoryModel> _categories = [];
  final List<FlashcardModel> _flashcards = [];
  int _idCounter = 0;

  String _nextId() => 'fc_${_idCounter++}';

  void _seed() {
    _categories.addAll(const [
      CategoryModel(id: 'programming', name: 'Programming', icon: Icons.code, color: Color(0xFF6C5DD3)),
      CategoryModel(id: 'science', name: 'Science', icon: Icons.science_outlined, color: Color(0xFF2ECC71)),
      CategoryModel(id: 'math', name: 'Math', icon: Icons.calculate_outlined, color: Color(0xFFF5A623)),
      CategoryModel(id: 'general', name: 'General Knowledge', icon: Icons.lightbulb_outline, color: Color(0xFFF7C948)),
      CategoryModel(id: 'database', name: 'Database', icon: Icons.storage_outlined, color: Color(0xFF4A90D9)),
      CategoryModel(id: 'history', name: 'History', icon: Icons.account_balance_outlined, color: Color(0xFFE65A5A)),
      CategoryModel(id: 'geography', name: 'Geography', icon: Icons.public, color: Color(0xFF17B6B0)),
      CategoryModel(id: 'literature', name: 'Literature', icon: Icons.menu_book_outlined, color: Color(0xFFB16CEA)),
    ]);

    final now = DateTime.now();

    void addCard(
      String categoryId,
      String question,
      String answer, {
      DateTime? lastStudiedAt,
      int studyCount = 0,
      bool bookmarked = false,
    }) {
      _flashcards.add(FlashcardModel(
        id: _nextId(),
        categoryId: categoryId,
        question: question,
        answer: answer,
        lastStudiedAt: lastStudiedAt,
        studyCount: studyCount,
        isBookmarked: bookmarked,
      ));
    }

    addCard(
      'programming',
      'What is encapsulation in object-oriented programming?',
      'Encapsulation is the concept of wrapping data (variables) and methods that work on the data within one unit (class) and restricting direct access to some of an object\'s components.',
      lastStudiedAt: now.subtract(const Duration(hours: 2)),
      studyCount: 3,
    );
    addCard('programming', 'What is inheritance?',
        'Inheritance lets a class acquire the properties and behavior of another class, enabling code reuse and a hierarchical relationship between classes.');
    addCard('programming', 'What is polymorphism?',
        'Polymorphism allows objects of different classes to be treated through a common interface, with each class providing its own implementation of shared behavior.');
    addCard('programming', 'What is abstraction?',
        'Abstraction means exposing only the essential features of an object while hiding the internal implementation details.');
    addCard('programming', 'What is a widget in Flutter?',
        'A widget is an immutable description of part of a user interface; Flutter rebuilds the widget tree to reflect state changes.');
    addCard('programming', 'What is the difference between StatelessWidget and StatefulWidget?',
        'A StatelessWidget has no mutable state and rebuilds only when its parent changes, while a StatefulWidget holds mutable state that can change over its lifetime.');
    addCard('programming', 'What is BLoC in Flutter?',
        'BLoC (Business Logic Component) is a state management pattern that separates business logic from the UI using streams of events and states.');
    addCard('programming', 'What is the difference between == and identical()?',
        '== checks value equality (which can be overridden), while identical() checks whether two references point to the exact same object instance.');
    addCard('programming', 'What is a Future in Dart?',
        'A Future represents a value or error that will be available at some point in the future, used for asynchronous operations.');
    addCard('programming', 'What is the difference between synchronous and asynchronous code?',
        'Synchronous code runs to completion before moving on, while asynchronous code can pause and resume, allowing other work to happen while waiting on a result.');
    addCard('programming', 'What is a mixin in Dart?',
        'A mixin is a way to reuse a class\'s code in multiple class hierarchies without using inheritance, added to a class using the "with" keyword.');
    addCard('programming', 'What is dependency injection?',
        'Dependency injection is a design pattern where an object\'s dependencies are provided from the outside rather than created internally, improving testability and decoupling.');

    addCard('science', 'What is Newton\'s First Law of Motion?',
        'An object at rest stays at rest, and an object in motion stays in motion at constant velocity, unless acted on by a net external force.');
    addCard('science', 'What is photosynthesis?',
        'Photosynthesis is the process by which plants use sunlight, water, and carbon dioxide to produce glucose and release oxygen.');
    addCard('science', 'What is the powerhouse of the cell?',
        'The mitochondria is often called the powerhouse of the cell because it generates most of the cell\'s supply of ATP energy.');
    addCard('science', 'What is the difference between mass and weight?',
        'Mass is the amount of matter in an object and stays constant, while weight is the force of gravity acting on that mass and can vary by location.');
    addCard('science', 'What is an atom made of?',
        'An atom is made of protons and neutrons in a central nucleus, surrounded by electrons orbiting in shells.');
    addCard('science', 'What is the speed of light?',
        'The speed of light in a vacuum is approximately 299,792 kilometers per second.');
    addCard('science', 'What is DNA?',
        'DNA (deoxyribonucleic acid) is the molecule that carries genetic instructions for the growth, development, and reproduction of living organisms.');
    addCard('science', 'What is the difference between a compound and a mixture?',
        'A compound is formed when elements chemically bond in fixed proportions, while a mixture is a physical combination of substances that can be separated.');

    addCard('math', 'What is the Pythagorean theorem?',
        'In a right triangle, the square of the hypotenuse equals the sum of the squares of the other two sides: a squared plus b squared equals c squared.');
    addCard('math', 'What is a prime number?',
        'A prime number is a natural number greater than 1 that has no positive divisors other than 1 and itself.');
    addCard('math', 'What is the derivative of x squared?', 'The derivative of x squared with respect to x is 2x.');
    addCard('math', 'What is the value of pi to two decimal places?', 'Pi is approximately 3.14.');

    addCard('general', 'Who developed the theory of relativity?',
        'Albert Einstein developed the theory of relativity, including special relativity in 1905 and general relativity in 1915.');
    addCard('general', 'What is the largest country by area?', 'Russia is the largest country in the world by total area.');
    addCard('general', 'How many continents are there?',
        'There are seven continents: Africa, Antarctica, Asia, Australia, Europe, North America, and South America.');
    addCard('general', 'What is the tallest mountain in the world?',
        'Mount Everest, on the border of Nepal and China, is the tallest mountain above sea level at 8,849 meters.');
    addCard('general', 'What is the currency of Japan?', 'The official currency of Japan is the Japanese Yen.');
    addCard('general', 'Who painted the Mona Lisa?', 'Leonardo da Vinci painted the Mona Lisa in the early 16th century.');

    addCard('database', 'What is normalization in databases?',
        'Normalization is the process of organizing data to reduce redundancy and improve data integrity by dividing data into related tables.');
    addCard('database', 'What is a primary key?',
        'A primary key is a column or set of columns that uniquely identifies each row in a database table.');
    addCard('database', 'What is the difference between SQL and NoSQL?',
        'SQL databases use structured tables with fixed schemas and relationships, while NoSQL databases store data more flexibly, often as documents, key-value pairs, or graphs.');
    addCard('database', 'What is a foreign key?',
        'A foreign key is a column that creates a link between two tables by referencing the primary key of another table.');
    addCard('database', 'What is an index in a database?',
        'An index is a data structure that improves the speed of data retrieval operations on a table, at the cost of extra storage and slower writes.');

    addCard('history', 'When did World War II end?', 'World War II ended in 1945.');
    addCard('history', 'Who was the first president of the United States?', 'George Washington was the first president of the United States.');
    addCard('history', 'What ancient civilization built the pyramids of Giza?', 'The ancient Egyptians built the pyramids of Giza.');

    addCard('geography', 'What is the longest river in the world?',
        'The Nile River is generally considered the longest river in the world, at roughly 6,650 kilometers.');
    addCard('geography', 'Which desert is the largest hot desert in the world?', 'The Sahara Desert in Africa is the largest hot desert in the world.');

    addCard('literature', 'Who wrote Romeo and Juliet?', 'William Shakespeare wrote the play Romeo and Juliet.');
  }

  @override
  Future<List<CategoryModel>> getCategories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_categories);
  }

  @override
  Future<List<FlashcardModel>> getFlashcards() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.unmodifiable(_flashcards);
  }

  @override
  Future<FlashcardModel> addFlashcard(FlashcardModel flashcard) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final created = flashcard.copyWith(id: _nextId());
    _flashcards.add(created);
    return created;
  }

  @override
  Future<FlashcardModel> updateFlashcard(FlashcardModel flashcard) async {
    await Future.delayed(const Duration(milliseconds: 200));
    final index = _flashcards.indexWhere((f) => f.id == flashcard.id);
    if (index == -1) {
      throw Exception('Flashcard not found: ${flashcard.id}');
    }
    _flashcards[index] = flashcard;
    return flashcard;
  }

  @override
  Future<void> deleteFlashcard(String flashcardId) async {
    await Future.delayed(const Duration(milliseconds: 200));
    _flashcards.removeWhere((f) => f.id == flashcardId);
  }
}
