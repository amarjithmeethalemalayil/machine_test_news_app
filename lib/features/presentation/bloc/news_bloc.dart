import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:machine_test_news_app/features/domain/entity/article_entity.dart';
import 'package:machine_test_news_app/features/domain/usecase/fetch_news_usecase.dart';
part 'news_event.dart';
part 'news_state.dart';

class NewsBloc extends Bloc<NewsEvent, NewsState> {
  final FetchNewsUseCase newsUseCase;

  List<Article> _articles = [];
  List<Article> _searchResults = [];
  String _searchQuery = '';

  NewsBloc({required this.newsUseCase}) : super(NewsInitial()) {
    on<FetchNewsEvent>(_onFetchNews);
    on<SearchArticlesEvent>(_onSearchArticles);
    on<ClearSearchEvent>(_onClearSearch);
  }

  Future<void> _onFetchNews(
    FetchNewsEvent event,
    Emitter<NewsState> emit,
  ) async {
    emit(NewsLoading());
    try {
      _articles = await newsUseCase(page: event.page, pageSize: event.pageSize);
      emit(NewsLoaded(articles: _articles));
    } catch (e) {
      emit(NewsError(e.toString()));
    }
  }

  void _onSearchArticles(SearchArticlesEvent event, Emitter<NewsState> emit) {
    _searchQuery = event.query.toLowerCase();

    if (_searchQuery.isEmpty) {
      _searchResults = [];
      emit(NewsLoaded(articles: _articles, searchQuery: ''));
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

    emit(NewsLoaded(articles: _searchResults, searchQuery: _searchQuery));
  }

  void _onClearSearch(ClearSearchEvent event, Emitter<NewsState> emit) {
    _searchResults = [];
    _searchQuery = '';
    emit(NewsLoaded(articles: _articles));
  }
}
