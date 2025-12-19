import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:typed_data';
import '../models/book.dart';

abstract class BooksRepository {
  Stream<List<Book>> getUserBooksStream(String userId);
  Future<void> addBook(Book book, XFile? coverImage);
  Future<void> updateBook(Book book);
  Future<void> deleteBook(String id);
}

class FirebaseBooksRepository implements BooksRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseStorage _storage = FirebaseStorage.instance;

  @override
  Stream<List<Book>> getUserBooksStream(String userId) {
    return _firestore
        .collection('books')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Book.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  @override
  Future<void> addBook(Book book, XFile? coverImage) async {
    String? imageUrl;

    if (coverImage != null) {
      Uint8List fileBytes = await coverImage.readAsBytes();

      final String filePath =
          'books/${book.userId}/${DateTime.now().millisecondsSinceEpoch}.jpg';
      final Reference storageRef = _storage.ref().child(filePath);

      final metadata = SettableMetadata(contentType: 'image/jpeg');
      final UploadTask uploadTask = storageRef.putData(fileBytes, metadata);

      final TaskSnapshot snapshot = await uploadTask;
      imageUrl = await snapshot.ref.getDownloadURL();
    }

    final bookToSave = Book(
      id: '',
      userId: book.userId,
      title: book.title,
      author: book.author,
      genre: book.genre,
      totalPages: book.totalPages,
      currentPage: book.currentPage,
      status: book.status,
      coverUrl: imageUrl,
    );

    await _firestore.collection('books').add(bookToSave.toMap());
  }

  @override
  Future<void> updateBook(Book book) async {
    await _firestore.collection('books').doc(book.id).update(book.toMap());
  }

  @override
  Future<void> deleteBook(String id) async {
    await _firestore.collection('books').doc(id).delete();
  }
}
