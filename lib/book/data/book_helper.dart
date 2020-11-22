import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';
import 'dart:async';
import 'package:http/http.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'book.dart';

class BookHelper {
  final String urlKey = '&key=AIzaSyDUvjeiqyNReaI09g-4K_7-sXuLXOAvIog';
  final String urlQuery = 'volumes?q=';
  final String urlBase = 'https://www.googleapis.com/books/v1/';

  Future<List<dynamic>> getBook(String query) async {
    final String url = urlBase + urlQuery + query + urlKey ;

    Response result = await http.get(url);

    if (result.statusCode == 200) {
      final jsonResponse = json.decode(result.body);
      final bookMap = jsonResponse['items'];
      List<dynamic> books = bookMap
          .map(
            (item) => Book.fromJson(item),
          )
          .toList();
      return books;
    } else {
      return null;
    }
  }
}
