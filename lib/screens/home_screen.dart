import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/book.dart';
import '../core/providers/reading_provider.dart';
import '../core/constants/app_strings.dart';
import 'book_details_screen.dart';
import 'add_book_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.myReadingTab)),
      body: StreamBuilder<List<Book>>(
        stream: context.read<ReadingProvider>().myBooksStream,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(
              child: Text("${AppStrings.error}: ${snapshot.error}"),
            );
          }
          final books = snapshot.data ?? [];

          if (books.isEmpty) {
            return const Center(child: Text(AppStrings.listEmpty));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: books.length,
            itemBuilder: (context, index) {
              final book = books[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: book.coverUrl != null
                      ? Image.network(
                          book.coverUrl!,
                          width: 50,
                          fit: BoxFit.cover,
                        )
                      : Container(
                          width: 50,
                          color: Colors.grey,
                          child: const Icon(Icons.book),
                        ),
                  title: Text(book.title),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(book.author),
                      LinearProgressIndicator(value: book.progressPercentage),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => BookDetailsScreen(book: book),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => const AddBookScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}
