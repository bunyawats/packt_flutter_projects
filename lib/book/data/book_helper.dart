import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'book.dart';
import '../ui/favorite_screen.dart';

class BookHelper {
  final String urlKey = '&key=AIzaSyDUvjeiqyNReaI09g-4K_7-sXuLXOAvIog';
  final String urlQuery = 'volumes?q=';
  final String urlBase = 'https://www.googleapis.com/books/v1/';

  Future<List<Book>> getBook(String query) async {
    final String url = urlBase + urlQuery + query + urlKey;

    Response result = await http.get(url);

    if (result.statusCode == 200) {
      final jsonResponse = json.decode(result.body);
      final bookMap = jsonResponse['items'];
      final books = bookMap
          .map(
            (item) => Book.fromJson(item),
          )
          .toList();
      return books.cast<Book>();
    } else {
      return null;
    }
  }

  Future addToFavorites(Book book) async {
    debugPrint('addToFavorites: $book');

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString(book.id);
    debugPrint('preferences id: $id');

    if (id == null) {
      await preferences.setString(book.id, json.encode(book.toJson()));
    }
  }

  Future removeFromFavorites(Book book, BuildContext context) async {
    debugPrint('removeFromFavorites: $book');

    SharedPreferences preferences = await SharedPreferences.getInstance();
    String id = preferences.getString(book.id);
    debugPrint('preferences id: $id');

    if (id != null) {
      preferences.remove(book.id);
      Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => FavoriteScreen(),
          ));
    }
  }

  Future<List<Book>> getFavorites() async {
    SharedPreferences preferences = await SharedPreferences.getInstance();
    List<Book> favBooks = List<Book>();
    Set allKeys = preferences.getKeys();
    if (allKeys.isNotEmpty) {
      for (int i = 0; i < allKeys.length; i++) {
        String key = allKeys.elementAt(i).toString();
        String value = preferences.get(key);
        dynamic json = jsonDecode(value);
        Book book = Book(
          json['id'],
          json['title'],
          json['authors'],
          json['description'],
          json['publisher'],
        );
        favBooks.add(book);
      }
    }

    return favBooks;
  }
}
