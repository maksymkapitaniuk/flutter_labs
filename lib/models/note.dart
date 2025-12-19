import 'package:cloud_firestore/cloud_firestore.dart';

class Note {
  final String id;
  final String bookId;
  final String text;
  final String? quote;
  final int? pageNumber;
  final DateTime createdAt;

  Note({
    required this.id,
    required this.bookId,
    required this.text,
    this.quote,
    this.pageNumber,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'bookId': bookId,
      'text': text,
      'quote': quote,
      'pageNumber': pageNumber,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }

  factory Note.fromMap(Map<String, dynamic> map, String id) {
    return Note(
      id: id,
      bookId: map['bookId'] ?? '',
      text: map['text'] ?? '',
      quote: map['quote'],
      pageNumber: map['pageNumber'],
      createdAt: (map['createdAt'] as Timestamp).toDate(),
    );
  }
}
