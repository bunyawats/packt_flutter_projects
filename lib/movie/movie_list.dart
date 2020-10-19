import 'package:flutter/material.dart';
import 'package:hello_world/movie/movie_detail.dart';
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

  Icon visibleIcon = Icon(Icons.search);
  Widget searchBar = Text('Movies');

  final String iconBase = 'https://image.tmdb.org/t/p/w92';
  final String defaultImage =
      'https://images.freeimages.com/images/large-previews/5eb/movie-clapboard-1184339.jpg';

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

  Future search(String text) async {
    var _movies = await helper.findMovies(text);
    setState(() {
      movieCount = _movies.length;
      movies = _movies;
    });
  }

  @override
  Widget build(BuildContext context) {
    NetworkImage image;
    return Scaffold(
      appBar: AppBar(
        title: searchBar,
        actions: <Widget>[
          IconButton(
            icon: visibleIcon,
            onPressed: () {
              setState(() {
                if (this.visibleIcon.icon == Icons.search) {
                  this.visibleIcon = Icon(Icons.cancel);
                  this.searchBar = TextField(
                    textInputAction: TextInputAction.search,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20.0,
                    ),
                    onSubmitted: (String text) {
                      search(text);
                    },
                  );
                } else {
                  setState(() {
                    this.visibleIcon = Icon(Icons.search);
                    this.searchBar = Text('Movies');
                  });
                }
              });
            },
          ),
        ],
      ),
      body: ListView.builder(
          itemCount: (this.movieCount != null) ? this.movieCount : 0,
          itemBuilder: (BuildContext context, int position) {
            if (movies[position].posterPath != null) {
              image = NetworkImage(iconBase + movies[position].posterPath);
            } else {
              image = NetworkImage(defaultImage);
            }
            return MovieCard(
              movies: movies,
              image: image,
              position: position,
            );
          }),
    );
  }
}

class MovieCard extends StatelessWidget {
  const MovieCard({
    Key key,
    @required this.movies,
    @required this.image,
    @required this.position,
  }) : super(key: key);

  final List movies;
  final NetworkImage image;
  final int position;

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.white,
      elevation: 2.0,
      child: ListTile(
        title: Text(movies[position].title),
        subtitle: Text(
            'Released: ${movies[position].releaseDate} - Votes ${movies[position].voteAverage}'),
        leading: CircleAvatar(
          backgroundImage: image,
        ),
        onTap: () {
          MaterialPageRoute route = MaterialPageRoute(
            builder: (_) => MovieDetail(movies[position]),
          );
          Navigator.push(context, route);
        },
      ),
    );
  }
}
