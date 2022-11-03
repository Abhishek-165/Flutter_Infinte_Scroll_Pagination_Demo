import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:statem/models/news_response.dart';
import 'package:statem/providers/news_provider.dart';
import 'package:statem/screens/article_item.dart';

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
  static const _pageSize = 100;

  final PagingController<int, Article> _pagingController =
      PagingController(firstPageKey: 1);

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageKey) {
      fetchApiCall(pageKey);
    });
    super.initState();
  }

  @override
  void dispose() {
    _pagingController.dispose();
    super.dispose();
  }

  Future<void> fetchApiCall(int pageKey) async {
    try {
      List<Article> articles =
          await Provider.of<NewsProvider>(context, listen: false)
              .fetchNews(pageKey);
      final isLastPage = articles.length < _pageSize;
      if (isLastPage) {
        _pagingController.appendLastPage(articles);
      } else {
        _pagingController.appendPage(articles, pageKey + 1);
      }
    } catch (error) {
      _pagingController.error = error;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: PagedListView<int, Article>(
      pagingController: _pagingController,
      builderDelegate: PagedChildBuilderDelegate<Article>(
        itemBuilder: (context, item, index) => ArticleItem(
          article: item,
        ),
      ),
    ));
  }
}
