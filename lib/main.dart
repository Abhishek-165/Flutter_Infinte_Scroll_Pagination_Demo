import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:statem/models/news_response.dart';
import 'package:statem/providers/news_provider.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MultiProvider(providers: [
        ChangeNotifierProvider<NewsProvider>(create: (_) => NewsProvider()),
      ], child: const MyHomePage(title: 'Flutter Demo Home Page')),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    super.initState();
    fetchApiCall();
  }

  _launchURL(String link) async {
    if (await canLaunchUrl(Uri.parse(link))) {
      await launchUrl(
        Uri.parse(link),
      );
    } else {
      throw 'Could not launch $link';
    }
  }

  Future<void> fetchApiCall() async {
    Provider.of<NewsProvider>(context, listen: false).fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    var news = Provider.of<NewsProvider>(context);
    return Scaffold(
        body: news.newsResponse == null
            ? const Center(
                child: Text("No Data"),
              )
            : RefreshIndicator(
                onRefresh: fetchApiCall,
                child: ListView.builder(
                    itemCount: news.getNewsArticles.length,
                    itemBuilder: (context, index) {
                      Article article = news.getNewsArticles[index];
                      return Container(
                        padding: const EdgeInsets.all(16.0),
                        child: GestureDetector(
                          onTap: () {
                            _launchURL(article.url);
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
                                    Image.network(article.urlToImage),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          top: 180, left: 8),
                                      child: Text(
                                        article.author,
                                        style: const TextStyle(
                                            color: Colors.white,
                                            fontWeight: FontWeight.bold),
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
                                            article.title,
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
                    }),
              ));
  }
}
