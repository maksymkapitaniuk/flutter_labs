import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import '../../models/book.dart';
import '../../repositories/books_repository.dart';
import '../../repositories/auth_repository.dart';

class ReadingProvider extends ChangeNotifier {
  final BooksRepository _booksRepository;
  final AuthRepository _authRepository = AuthRepository();

  ReadingProvider({required BooksRepository booksRepository})
    : _booksRepository = booksRepository;

  Stream<List<Book>> get myBooksStream {
    final user = _authRepository.currentUser;
    if (user != null) {
      return _booksRepository.getUserBooksStream(user.uid);
    }
    return Stream.value([]);
  }

  Future<void> addBook({
    required String title,
    required String author,
    required String genre,
    required int totalPages,
    required String status,
    XFile? coverImage,
  }) async {
    final user = _authRepository.currentUser;
    if (user == null) return;

    final newBook = Book(
      id: '',
      userId: user.uid,
      title: title,
      author: author,
      genre: genre,
      totalPages: totalPages,
      status: status,
    );

    await _booksRepository.addBook(newBook, coverImage);
  }

  Future<void> updateBookProgress(
    Book book,
    int newPage,
    String newStatus,
  ) async {
    final updatedBook = book.copyWith(currentPage: newPage, status: newStatus);
    await _booksRepository.updateBook(updatedBook);
  }
}
