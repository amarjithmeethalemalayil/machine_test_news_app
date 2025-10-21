part of 'news_bloc.dart';

abstract class NewsEvent {}

class FetchNewsEvent extends NewsEvent {
  final int page;
  final int pageSize;

  FetchNewsEvent({required this.page, required this.pageSize});
}

class SearchArticlesEvent extends NewsEvent {
  final String query;

  SearchArticlesEvent(this.query);
}

class ClearSearchEvent extends NewsEvent {}
