import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:statem/models/news_response.dart';

class NewsProvider with ChangeNotifier {
  NewsResponse? newsResponse;

  List<Article> get getNewsArticles => newsResponse!.articles;

  var API_KEY = "";

  Future<List<Article>> fetchNews(int pageNo) async {
    print("PageNo : $pageNo");
    var client = http.Client();

    try {
      var response = await client.get(Uri.parse(
          "https://newsapi.org/v2/everything?q=bitcoin&apiKey=$API_KEY&page=$pageNo"));

      if (response.statusCode == 200) {
        newsResponse = NewsResponse.fromMap(jsonDecode(response.body));
        notifyListeners();
        return getNewsArticles;
      } else {}
    } catch (e) {
      print(e);
      return [];
    } finally {
      client.close();
    }
    notifyListeners();
    return [];
  }
}
