import 'package:flutter/material.dart';

import '../../domain/entity/article_entity.dart';
import '../../domain/usecase/fetch_news_usecase.dart';

class NewsProvider with ChangeNotifier {
  final FetchNewsUseCase newsUseCase;

  NewsProvider({required this.newsUseCase});

  List<Article> _articles = [];
  List<Article> _searchResults = [];
  bool _isLoading = false;
  String? _errorMessage;
  String _searchQuery = '';

  List<Article> get articles =>
      _searchQuery.isEmpty ? _articles : _searchResults;

  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String get searchQuery => _searchQuery;

  Future<void> fetchNewsArticles({
    required int page,
    required int pageSize,
  }) async {
    _isLoading = true;
    notifyListeners();

    try {
      _articles = await newsUseCase(
        page: page,
        pageSize: pageSize,
      );
      _errorMessage = null;
    } catch (e) {
      _errorMessage = e.toString();
      _articles = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchArticles(String query) {
    _searchQuery = query.toLowerCase();

    if (_searchQuery.isEmpty) {
      _searchResults = [];
      notifyListeners();
      return;
    }

    _searchResults = _articles.where((article) {
      final title = article.title?.toLowerCase() ?? '';
      final description = article.description?.toLowerCase() ?? '';
      final content = article.content?.toLowerCase() ?? '';

      return title.contains(_searchQuery) ||
          description.contains(_searchQuery) ||
          content.contains(_searchQuery);
    }).toList();

    notifyListeners();
  }

  void clearSearch() {
    _searchResults = [];
    _searchQuery = '';
    notifyListeners();
  }
}
