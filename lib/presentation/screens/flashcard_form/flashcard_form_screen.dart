import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import '../../../data/models/flashcard_model.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_text_styles.dart';
import '../../../core/widgets/confirm_action_dialog.dart';
import '../../../core/widgets/custom_button.dart';
import '../../../core/widgets/custom_text_field.dart';
import '../../bloc/flashcard/flashcard_bloc.dart';
import '../../bloc/flashcard/flashcard_event.dart';
import '../../bloc/flashcard/flashcard_state.dart';

/// Single screen that handles both "Add New Flashcard" and
/// "Edit Flashcard" from the mockup, switching on whether
/// [editingFlashcardId] is null.
class FlashcardFormScreen extends StatefulWidget {
  final String? editingFlashcardId;
  final String? initialCategoryId;

  const FlashcardFormScreen({super.key, this.editingFlashcardId, this.initialCategoryId});

  bool get isEditing => editingFlashcardId != null;

  @override
  State<FlashcardFormScreen> createState() => _FlashcardFormScreenState();
}

class _FlashcardFormScreenState extends State<FlashcardFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  final _answerController = TextEditingController();
  String? _selectedCategoryId;
  bool _initialized = false;

  @override
  void dispose() {
    _questionController.dispose();
    _answerController.dispose();
    super.dispose();
  }

  void _initializeIfNeeded(FlashcardState state) {
    if (_initialized) return;
    _initialized = true;

    if (widget.isEditing) {
      final card = state.flashcards.firstWhere((f) => f.id == widget.editingFlashcardId);
      _questionController.text = card.question;
      _answerController.text = card.answer;
      _selectedCategoryId = card.categoryId;
    } else {
      _selectedCategoryId = widget.initialCategoryId ?? (state.categories.isNotEmpty ? state.categories.first.id : null);
    }
  }

  void _onSave(FlashcardState state) {
    if (!_formKey.currentState!.validate() || _selectedCategoryId == null) return;

    final bloc = context.read<FlashcardBloc>();
    if (widget.isEditing) {
      final existing = state.flashcards.firstWhere((f) => f.id == widget.editingFlashcardId);
      bloc.add(FlashcardUpdateRequested(existing.copyWith(
        categoryId: _selectedCategoryId,
        question: _questionController.text.trim(),
        answer: _answerController.text.trim(),
      )));
    } else {
      bloc.add(FlashcardAddRequested(FlashcardModel(
        id: '',
        categoryId: _selectedCategoryId!,
        question: _questionController.text.trim(),
        answer: _answerController.text.trim(),
      )));
    }
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(widget.isEditing ? 'Flashcard updated!' : 'Flashcard added!'),
        backgroundColor: AppColors.primary,
      ),
    );
    context.pop();
  }

  void _onDelete() {
    showDialog(
      context: context,
      builder: (_) => ConfirmActionDialog(
        icon: Icons.delete_outline,
        title: 'Delete Flashcard',
        message: 'Are you sure you want to delete this flashcard? This action cannot be undone.',
        confirmLabel: 'Delete',
        onConfirm: () {
          context.read<FlashcardBloc>().add(FlashcardDeleteRequested(widget.editingFlashcardId!));
          context.pop();
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FlashcardBloc, FlashcardState>(
      builder: (context, state) {
        _initializeIfNeeded(state);

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () => context.pop(),
            ),
            title: Text(widget.isEditing ? 'Edit Flashcard' : 'Add New Flashcard', style: AppTextStyles.heading3),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 12),
                child: TextButton(
                  onPressed: () => _onSave(state),
                  child: Text('Save', style: AppTextStyles.button.copyWith(color: AppColors.primary)),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Category', style: AppTextStyles.heading3.copyWith(fontSize: 14)),
                  const SizedBox(height: 8),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedCategoryId,
                    items: state.categories
                        .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                        .toList(),
                    onChanged: (value) => setState(() => _selectedCategoryId = value),
                    validator: (value) => value == null ? 'Please select a category' : null,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: 'Question',
                    hint: 'Enter your question',
                    controller: _questionController,
                    maxLines: 3,
                    validator: (value) =>
                        (value == null || value.trim().isEmpty) ? 'Question is required' : null,
                  ),
                  const SizedBox(height: 20),
                  AppTextField(
                    label: 'Answer',
                    hint: 'Enter the answer',
                    controller: _answerController,
                    maxLines: 5,
                    validator: (value) =>
                        (value == null || value.trim().isEmpty) ? 'Answer is required' : null,
                  ),
                  const SizedBox(height: 28),
                  if (widget.isEditing) ...[
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: 'Delete',
                            variant: AppButtonVariant.danger,
                            onPressed: _onDelete,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            label: 'Update Flashcard',
                            onPressed: () => _onSave(state),
                          ),
                        ),
                      ],
                    ),
                  ] else ...[
                    Row(
                      children: [
                        Expanded(
                          child: AppButton(
                            label: 'Cancel',
                            variant: AppButtonVariant.outline,
                            onPressed: () => context.pop(),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppButton(
                            label: 'Save Flashcard',
                            onPressed: () => _onSave(state),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
