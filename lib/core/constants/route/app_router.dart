import 'package:flutter/material.dart';
import 'package:machine_test_news_app/features/presentation/pages/news_detail_page.dart';

class AppRouter {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/news-detail':
        final args = settings.arguments as Map<String, dynamic>;
        return MaterialPageRoute(
          builder: (context) => NewsDetailPage(
            imageUrl: args['imageUrl'],
            title: args['title'],
            content: args['content'],
            author: args['author'],
            publishedAt: args['publishedAt'],
            heroTag: args['heroTag'],
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (context) =>
              const Scaffold(body: Center(child: Text('Page not found 🧐'))),
        );
    }
  }
}
