import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../data/models/flashcard_model.dart';
import '../../data/repositories/flashcard_repository.dart';
import '../../routes/injection_container.dart';

class AddFlashcardPage extends StatefulWidget {
  final bool isEditing;
  const AddFlashcardPage({super.key, this.isEditing = false});

  @override
  State<AddFlashcardPage> createState() => _AddFlashcardPageState();
}

class _AddFlashcardPageState extends State<AddFlashcardPage> {
  String selectedCategoryName = 'Programming';
  String selectedCategoryId = 'programming';
  final TextEditingController _questionController = TextEditingController();
  final TextEditingController _answerController = TextEditingController();

  final Map<String, String> categoryMap = {
    'Programming': 'programming',
    'Science': 'science',
    'Math': 'math',
    'General Knowledge': 'general',
    'Database': 'database',
  };

  @override
  void initState() {
    super.initState();
    if (widget.isEditing) {
      _questionController.text = 'What is encapsulation in object-oriented programming?';
      _answerController.text = 'Encapsulation is the concept of wrapping data (variables) and methods that work on the data within one unit (class) and restricting direct access to some of an object\'s components.';
    }
  }

  Future<void> _saveFlashcard() async {
    if (_questionController.text.isEmpty || _answerController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      return;
    }

    final flashcard = FlashcardModel(
      id: const Uuid().v4(),
      question: _questionController.text,
      answer: _answerController.text,
      categoryId: selectedCategoryId,
    );

    await sl<FlashcardRepository>().addFlashcard(flashcard);
    if (mounted) {
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: theme.appBarTheme.backgroundColor,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.appBarTheme.foregroundColor),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          widget.isEditing ? 'Edit Flashcard' : 'Add New Flashcard',
          style: TextStyle(
            color: theme.appBarTheme.foregroundColor, 
            fontWeight: FontWeight.bold
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: ElevatedButton(
              onPressed: _saveFlashcard,
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF6A4BC1),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                elevation: 0,
              ),
              child: const Text('Save'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Category', 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 16,
                color: theme.textTheme.titleMedium?.color
              )
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: theme.dividerColor),
                color: theme.cardColor,
              ),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<String>(
                  value: selectedCategoryName,
                  isExpanded: true,
                  dropdownColor: theme.cardColor,
                  style: TextStyle(color: theme.textTheme.bodyMedium?.color),
                  items: categoryMap.keys
                      .map((String value) => DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          ))
                      .toList(),
                  onChanged: (newValue) {
                    setState(() {
                      selectedCategoryName = newValue!;
                      selectedCategoryId = categoryMap[newValue]!;
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Question', 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 16,
                color: theme.textTheme.titleMedium?.color
              )
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _questionController,
              maxLines: 4,
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                hintText: 'Enter your question',
                hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
                fillColor: theme.cardColor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Answer', 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                fontSize: 16,
                color: theme.textTheme.titleMedium?.color
              )
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _answerController,
              maxLines: 6,
              style: TextStyle(color: theme.textTheme.bodyLarge?.color),
              decoration: InputDecoration(
                hintText: 'Enter the answer',
                hintStyle: TextStyle(color: theme.textTheme.bodySmall?.color),
                fillColor: theme.cardColor,
                filled: true,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: theme.dividerColor),
                ),
              ),
            ),
            const SizedBox(height: 40),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: OutlinedButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      style: OutlinedButton.styleFrom(
                        foregroundColor: theme.textTheme.bodyLarge?.color,
                        side: BorderSide(color: theme.dividerColor),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                      ),
                      child: const Text('Cancel'),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: SizedBox(
                    height: 56,
                    child: ElevatedButton(
                      onPressed: _saveFlashcard,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF6A4BC1),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        elevation: 0,
                      ),
                      child: Text(widget.isEditing ? 'Update Flashcard' : 'Save Flashcard'),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
