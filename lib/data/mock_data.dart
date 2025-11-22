class Book {
  final String title;
  final String author;
  final String genre;
  final String coverUrl;
  final int? currentPage;
  final int totalPages;
  final String status;
  final bool isPrivate;
  final String publicationNumber;

  const Book({
    required this.title,
    required this.author,
    required this.genre,
    required this.coverUrl,
    this.currentPage,
    required this.totalPages,
    required this.status,
    required this.isPrivate,
    required this.publicationNumber,
  });

  double get progress => currentPage != null ? currentPage! / totalPages : 1.0;
}

class MockData {
  static const String userEmail = "my_email@somemail.com";
  static const String userName = "John Doe";

  static const List<Book> myReadingList = [
    Book(
      title: "The Story of a Lonely Boy",
      author: "Korina Villanueva",
      genre: "Adventure",
      coverUrl: "assets/images/the_story_of_a_lonely_boy.jpg",
      currentPage: 170,
      totalPages: 275,
      status: "In Progress",
      isPrivate: true,
      publicationNumber: "Abc123",
    ),
    Book(
      title: "Beyond the Ocean Door",
      author: "Amisha Sathi",
      genre: "Roman",
      coverUrl: "assets/images/beyond_the_ocean_door.jpg",
      currentPage: 312,
      totalPages: 380,
      status: "Delayed",
      isPrivate: false,
      publicationNumber: "Abc124",
    ),
  ];
}
