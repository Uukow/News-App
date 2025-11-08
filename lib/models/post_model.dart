import 'package:hive/hive.dart';

part 'post_model.g.dart';

@HiveType(typeId: 0)
class Post extends HiveObject {
  @HiveField(0)
  final int id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String excerpt;

  @HiveField(3)
  final String content;

  @HiveField(4)
  final String date;

  @HiveField(5)
  final int author;

  @HiveField(6)
  final String authorName;

  @HiveField(7)
  final String? featuredImageUrl;

  @HiveField(8)
  final List<int> categories;

  @HiveField(9)
  final String link;

  Post({
    required this.id,
    required this.title,
    required this.excerpt,
    required this.content,
    required this.date,
    required this.author,
    required this.authorName,
    this.featuredImageUrl,
    required this.categories,
    required this.link,
  });

  factory Post.fromJson(Map<String, dynamic> json, {String? authorName, String? featuredImageUrl}) {
    return Post(
      id: json['id'] ?? 0,
      title: _parseRendered(json['title']),
      excerpt: _parseRendered(json['excerpt']),
      content: _parseRendered(json['content']),
      date: json['date'] ?? '',
      author: json['author'] ?? 0,
      authorName: authorName ?? 'Unknown Author',
      featuredImageUrl: featuredImageUrl,
      categories: List<int>.from(json['categories'] ?? []),
      link: json['link'] ?? '',
    );
  }

  static String _parseRendered(dynamic field) {
    if (field == null) return '';
    if (field is Map && field.containsKey('rendered')) {
      return field['rendered'] ?? '';
    }
    return field.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': {'rendered': title},
      'excerpt': {'rendered': excerpt},
      'content': {'rendered': content},
      'date': date,
      'author': author,
      'authorName': authorName,
      'featuredImageUrl': featuredImageUrl,
      'categories': categories,
      'link': link,
    };
  }
}

