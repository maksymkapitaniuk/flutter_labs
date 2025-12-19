class Book {
  final String id;
  final String userId;
  final String title;
  final String author;
  final String genre;
  final int totalPages;
  final int currentPage;
  final String status;
  final String? coverUrl;

  Book({
    required this.id,
    required this.userId,
    required this.title,
    required this.author,
    required this.genre,
    required this.totalPages,
    this.currentPage = 0,
    this.status = 'Planned',
    this.coverUrl,
  });

  double get progressPercentage =>
      totalPages > 0 ? currentPage / totalPages : 0.0;

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'title': title,
      'author': author,
      'genre': genre,
      'totalPages': totalPages,
      'currentPage': currentPage,
      'status': status,
      'coverUrl': coverUrl,
    };
  }

  factory Book.fromMap(Map<String, dynamic> map, String id) {
    return Book(
      id: id,
      userId: map['userId'] ?? '',
      title: map['title'] ?? '',
      author: map['author'] ?? '',
      genre: map['genre'] ?? '',
      totalPages: map['totalPages'] ?? 0,
      currentPage: map['currentPage'] ?? 0,
      status: map['status'] ?? 'Planned',
      coverUrl: map['coverUrl'],
    );
  }

  Book copyWith({int? currentPage, String? status}) {
    return Book(
      id: id,
      userId: userId,
      title: title,
      author: author,
      genre: genre,
      totalPages: totalPages,
      currentPage: currentPage ?? this.currentPage,
      status: status ?? this.status,
      coverUrl: coverUrl,
    );
  }
}
