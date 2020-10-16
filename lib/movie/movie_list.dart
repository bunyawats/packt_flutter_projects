import 'package:flutter/material.dart';
import 'http_helper.dart';

class MovieList extends StatefulWidget {
  @override
  _MovieListState createState() => _MovieListState();
}

class _MovieListState extends State<MovieList> {
  String result;
  HttpHelper helper;

  int movieCount;
  List movies;

  @override
  void initState() {
    result = '';
    helper = HttpHelper();
    initialize();
    super.initState();
  }

  Future initialize() async {
    var _movies = List();
    _movies = await helper.getUpcoming();
    setState(() {
      movieCount = _movies.length;
      movies = _movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Movies'),
      ),
      body: ListView.builder(
          itemCount: (this.movieCount != null) ? this.movieCount : 0,
          itemBuilder: (BuildContext context, int position) {
            return Card(
              color: Colors.white,
              elevation: 2.0,
              child: ListTile(
                title: Text(movies[position].title),
                subtitle: Text(
                    'Released: ${movies[position].releaseDate} - Votes ${movies[position].voteAverage}'),
              ),
            );
          }),
    );
  }
}
