import 'dart:convert';
import '../../domain/entity/article_entity.dart';

class ArticleModel extends Article {
  ArticleModel({
    required super.source,
    super.author,
    super.title,
    super.description,
    super.url,
    super.urlToImage,
    super.publishedAt,
    super.content,
  });

  factory ArticleModel.fromRawJson(String str) =>
      ArticleModel.fromJson(json.decode(str) as Map<String, dynamic>);

  String toRawJson() => json.encode(toJson());

  static List<ArticleModel> listFromRawJson(String str) {
    final parsed = json.decode(str);
    if (parsed is List) {
      return parsed
          .map((e) => ArticleModel.fromJson(e as Map<String, dynamic>))
          .toList();
    }
    return [];
  }

  factory ArticleModel.fromJson(Map<String, dynamic> json) => ArticleModel(
    source: SourceModel.fromJson(json['source'] as Map<String, dynamic>? ?? {}),
    author: json['author'] as String?,
    title: json['title'] as String?,
    description: json['description'] as String?,
    url: json['url'] as String?,
    urlToImage: json['urlToImage'] as String?,
    publishedAt: _parseDate(json['publishedAt'] as String?),
    content: json['content'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'source': (source as SourceModel).toJson(),
    'author': author,
    'title': title,
    'description': description,
    'url': url,
    'urlToImage': urlToImage,
    'publishedAt': publishedAt?.toUtc().toIso8601String(),
    'content': content,
  };

  static DateTime? _parseDate(String? s) {
    if (s == null) return null;
    return DateTime.tryParse(s);
  }
}

class SourceModel extends Source {
  SourceModel({super.id, super.name});

  factory SourceModel.fromJson(Map<String, dynamic> json) => SourceModel(
    id: json['id'] as String?,
    name: json['name'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
  };
}
