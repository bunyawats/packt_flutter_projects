class Book {
  String id;
  String title;
  String authors;
  String description;
  String publisher;

  Book(
    this.id,
    this.title,
    this.authors,
    this.description,
    this.publisher,
  );

  factory Book.fromJson(Map<String, dynamic> paredJson) {
    final String id = paredJson['id'];
    final dynamic volumeInfo = paredJson['volumeInfo'];
    final String title = volumeInfo['title'];

    String authors =
        volumeInfo['authors'] == null ? '' : volumeInfo['authors'].toString();
    authors = authors.replaceAll('[', '');
    authors = authors.replaceAll(']', '');
    final String description = volumeInfo['description'] == null
        ? ''
        : volumeInfo['description'].toString();
    final String publisher = volumeInfo['publisher'] == null
        ? ''
        : volumeInfo['publisher'].toString();

    return Book(
      id,
      title,
      authors,
      description,
      publisher,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'authors': authors,
      'description': description,
      'publisher': publisher,
    };
  }
}
