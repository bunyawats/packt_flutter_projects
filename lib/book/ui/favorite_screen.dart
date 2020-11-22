import 'package:flutter/material.dart';
import 'ui.dart';
import '../data/book_helper.dart';
import '../app_book.dart';
import '../data/book.dart';

class FavoriteScreen extends StatefulWidget {
  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  BookHelper helper;
  List<Book> books = List<Book>();
  int bookCount;

  Future initalize() async {
    books = await helper.getFavorites();
    setState(() {
      bookCount = books.length;
      books = books;
    });
  }

  @override
  void initState() {
    helper = BookHelper();
    initalize();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    bool isSmall = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Favorite Books'),
        actions: <Widget>[
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: isSmall ? Icon(Icons.home) : Text('Home'),
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MyHomePage(),
                ),
              );
            },
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(20),
              child: isSmall ? Icon(Icons.star) : Text('Favorites'),
            ),
          ),
        ],
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(20),
            child: Text('My Favorite Books'),
          ),
          Padding(
            padding: EdgeInsets.all(20),
            child: isSmall ? BookList(books, true) : BookTable(books, true),
          ),
        ],
      ),
    );
  }
}
