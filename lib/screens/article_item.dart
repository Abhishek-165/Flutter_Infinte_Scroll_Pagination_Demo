import 'package:flutter/material.dart';
import 'package:statem/models/news_response.dart';
import 'package:url_launcher/url_launcher.dart';

class ArticleItem extends StatefulWidget {
  const ArticleItem({required this.article, super.key});

  final Article article;

  @override
  State<ArticleItem> createState() => _ArticleItemState();
}

class _ArticleItemState extends State<ArticleItem> {
  _launchURL(String link) async {
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(
        Uri.parse(link),
      );
    } else {
      throw 'Could not launch $link';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16.0),
      child: GestureDetector(
        onTap: () {
          _launchURL(widget.article.url);
        },
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          child: Column(
            children: <Widget>[
              Stack(
                children: <Widget>[
                  Image.network(widget.article.urlToImage),
                  Padding(
                    padding: const EdgeInsets.only(top: 180, left: 8),
                    child: Text(
                      widget.article.author,
                      style: const TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              ),
              Row(
                children: <Widget>[
                  Flexible(
                    child: Container(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          widget.article.title,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontFamily: 'hpsimplified'),
                        )),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
