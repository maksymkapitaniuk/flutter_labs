import 'package:flutter/material.dart';

import '../core/constants/app_strings.dart';
import '../repositories/notes_repository.dart';
import '../models/note.dart';

class AddNoteScreen extends StatefulWidget {
  final String bookId;
  const AddNoteScreen({super.key, required this.bookId});

  @override
  State<AddNoteScreen> createState() => _AddNoteScreenState();
}

class _AddNoteScreenState extends State<AddNoteScreen> {
  final _textController = TextEditingController();
  final _quoteController = TextEditingController();
  final _pageController = TextEditingController();

  bool _isLoading = false;

  void _saveNote() async {
    if (_textController.text.trim().isEmpty) return;

    setState(() => _isLoading = true);

    try {
      final note = Note(
        id: '',
        bookId: widget.bookId,
        text: _textController.text.trim(),
        quote: _quoteController.text.trim().isEmpty
            ? null
            : _quoteController.text.trim(),
        pageNumber: int.tryParse(_pageController.text),
        createdAt: DateTime.now(),
      );

      final repository = FirebaseNotesRepository();
      await repository.addNote(note);

      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${AppStrings.error}: $e')));
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  void dispose() {
    _textController.dispose();
    _quoteController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.newNote)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: const InputDecoration(
                labelText: AppStrings.noteTextLabel,
                border: OutlineInputBorder(),
                alignLabelWithHint: true,
              ),
              maxLines: 5,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _quoteController,
              decoration: const InputDecoration(
                labelText: AppStrings.quoteLabel,
                border: OutlineInputBorder(),
                prefixIcon: Icon(Icons.format_quote),
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: _pageController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: AppStrings.pageNumberLabel,
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _saveNote,
                child: _isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : const Text(AppStrings.saveNoteButton),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
