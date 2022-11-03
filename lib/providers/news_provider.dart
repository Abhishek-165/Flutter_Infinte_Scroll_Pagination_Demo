import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:statem/models/news_response.dart';

class NewsProvider with ChangeNotifier {
  NewsResponse? newsResponse;

  List<Article> get getNewsArticles => newsResponse!.articles;

  void fetchNews() async {
    var client = http.Client();

    try {
      var response = await client.get(Uri.parse(
          "https://newsapi.org/v2/everything?q=bitcoin&apiKey=e8dc5d8e271d4415bf89b00d9dfa142c"));

      if (response.statusCode == 200) {
        newsResponse = NewsResponse.fromMap(jsonDecode(response.body));
      } else {}
    } catch (e) {
      print(e);
      return;
    } finally {
      client.close();
    }
    notifyListeners();
  }
}
