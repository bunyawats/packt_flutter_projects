import 'dart:convert';
import 'dart:io';

import 'package:hello_world/movie/movie.dart';
import 'package:http/http.dart' as http;

class HttpHelper {
  final String urlKey = 'api_key=d1386f21b6198d7166e6fa7647042b43';
  final String baseUrl = 'https://api.themoviedb.org/3/movie';
  final String urlUpcoming = '/upcoming?';
  final String urlLanguage = '&language=en-US';

  Future<List> getUpcoming() async {
    final String upcoming = baseUrl + urlUpcoming + urlKey + urlLanguage;
    print('upcoming: $upcoming');

    http.Response result = await http.get(upcoming);

    if (result.statusCode == HttpStatus.ok) {
      final jsonResponse = json.decode(result.body);
      final movieMap = jsonResponse['results'];
      List movies = movieMap.map((item) => Movie.formJson(item)).toList();
      return movies;
    } else {
      return null;
    }
  }
}
