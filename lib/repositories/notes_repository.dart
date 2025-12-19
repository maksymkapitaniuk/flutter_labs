import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/note.dart';

abstract class NotesRepository {
  Stream<List<Note>> getNotesStream(String bookId);
  Future<void> addNote(Note note);
  Future<void> deleteNote(String id);
}

class FirebaseNotesRepository implements NotesRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<Note>> getNotesStream(String bookId) {
    return _firestore
        .collection('notes')
        .where('bookId', isEqualTo: bookId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Note.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  @override
  Future<void> addNote(Note note) async {
    await _firestore.collection('notes').add(note.toMap());
  }

  @override
  Future<void> deleteNote(String id) async {
    await _firestore.collection('notes').doc(id).delete();
  }
}
