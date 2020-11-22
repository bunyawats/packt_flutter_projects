import 'package:flutter/material.dart';
import 'data/book_helper.dart';
import 'data/book.dart';
import 'ui/ui.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'My Books',
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BookHelper helper;
  List<Book> books = List<Book>();
  int bookCount;
  TextEditingController txtSearchController;

  @override
  void initState() {
    helper = BookHelper();
    txtSearchController = TextEditingController();
    initialize();

    super.initState();
  }

  Future initialize() async {
    books = await helper.getBook('Flutter');
    setState(() {
      bookCount = books.length;
      books = books;
    });
  }

  @override
  Widget build(BuildContext context) {
    bool isSmall = MediaQuery.of(context).size.width < 600;
    return Scaffold(
      appBar: AppBar(
        title: Text('My Books'),
        actions: <Widget>[
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: isSmall ? Icon(Icons.home) : Text('Home'),
            ),
          ),
          InkWell(
            child: Padding(
              padding: EdgeInsets.all(20.0),
              child: isSmall ? Icon(Icons.star) : Text('Favorites'),
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20.0),
              child: Row(
                children: <Widget>[
                  Text('Search Box'),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    width: 200,
                    child: TextField(
                      controller: txtSearchController,
                      keyboardType: TextInputType.text,
                      textInputAction: TextInputAction.search,
                      onSubmitted: (text) {
                        helper.getBook(text).then((value) {
                          setState(() {
                            books = value;
                          });
                        });
                      },
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.all(20.0),
                    child: IconButton(
                      icon: Icon(Icons.search),
                      onPressed: () => helper.getBook(
                        txtSearchController.text,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.all(20.0),
              child: isSmall ? BookList(books, false) : BookTable(books, false),
            )
          ],
        ),
      ),
    );
  }
}
