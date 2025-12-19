import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../core/constants/app_strings.dart';
import '../repositories/notes_repository.dart';
import '../models/book.dart';
import '../models/note.dart';
import '../core/providers/reading_provider.dart';
import 'add_note_screen.dart';

class BookDetailsScreen extends StatelessWidget {
  final Book book;

  final NotesRepository _notesRepository = FirebaseNotesRepository();

  BookDetailsScreen({super.key, required this.book});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(book.title)),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (book.coverUrl != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 16.0),
                      child: Center(
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(8),
                          child: Image.network(
                            book.coverUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return const Center(child: Icon(Icons.error));
                            },
                          ),
                        ),
                      ),
                    ),
                  Text(
                    "${AppStrings.author}: ${book.author}",
                    style: const TextStyle(fontSize: 18),
                  ),
                  Text("${AppStrings.genre}: ${book.genre}"),
                  const SizedBox(height: 16),
                  Text(
                    "${AppStrings.progress}: ${book.currentPage} / ${book.totalPages}",
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(value: book.progressPercentage),
                  const SizedBox(height: 16),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () => _showUpdateDialog(context),
                      child: const Text(AppStrings.updateProgressButton),
                    ),
                  ),
                ],
              ),
            ),
            const Divider(),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    AppStrings.notes,
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  IconButton(
                    icon: const Icon(Icons.note_add),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => AddNoteScreen(bookId: book.id),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            StreamBuilder<List<Note>>(
              stream: _notesRepository.getNotesStream(book.id),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(
                    child: Text("${AppStrings.error}: ${snapshot.error}"),
                  );
                }

                final notes = snapshot.data ?? [];

                if (notes.isEmpty) {
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(child: Text(AppStrings.noNotes)),
                  );
                }

                return ListView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: notes.length,
                  itemBuilder: (context, index) {
                    final note = notes[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 4,
                      ),
                      child: ListTile(
                        title: Text(note.text),
                        subtitle: note.quote != null && note.quote!.isNotEmpty
                            ? Text(
                                "${AppStrings.quote}: \"${note.quote}\"",
                                style: const TextStyle(
                                  fontStyle: FontStyle.italic,
                                ),
                              )
                            : null,
                        trailing: note.pageNumber != null
                            ? Text("${AppStrings.page} ${note.pageNumber}")
                            : null,
                      ),
                    );
                  },
                );
              },
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  void _showUpdateDialog(BuildContext context) {
    final controller = TextEditingController(text: book.currentPage.toString());
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.updatePage),
        content: TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: const InputDecoration(
            labelText: AppStrings.currentPage,
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(AppStrings.cancel),
          ),
          TextButton(
            onPressed: () {
              int? newPage = int.tryParse(controller.text);
              if (newPage != null) {
                if (newPage > book.totalPages) newPage = book.totalPages;
                if (newPage < 0) newPage = 0;

                String newStatus = AppStrings.inProgressStatus;
                if (newPage == book.totalPages) {
                  newStatus = AppStrings.completedStatus;
                }
                if (newPage == 0) {
                  newStatus = AppStrings.plannedStatus;
                }

                context.read<ReadingProvider>().updateBookProgress(
                  book,
                  newPage,
                  newStatus,
                );
                Navigator.pop(context);
              }
            },
            child: const Text(AppStrings.saveBookButton),
          ),
        ],
      ),
    );
  }
}
