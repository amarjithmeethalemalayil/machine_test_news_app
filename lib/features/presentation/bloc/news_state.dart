part of 'news_bloc.dart';

abstract class NewsState {}

class NewsInitial extends NewsState {}

class NewsLoading extends NewsState {}

class NewsLoaded extends NewsState {
  final List<Article> articles;
  final String searchQuery;

  NewsLoaded({required this.articles, this.searchQuery = ''});
}

class NewsError extends NewsState {
  final String message;

  NewsError(this.message);
}
