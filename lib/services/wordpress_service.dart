import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/post_model.dart';
import '../models/category_model.dart';
import '../models/author_model.dart';

class WordPressService {
  static const String baseUrl = 'https://uukow.com/wp-json/wp/v2';
  
  // Cache for authors to avoid repeated API calls
  final Map<int, Author> _authorsCache = {};

  /// Fetch posts with pagination
  Future<List<Post>> fetchPosts({int page = 1, int perPage = 10}) async {
    try {
      final url = Uri.parse('$baseUrl/posts?page=$page&per_page=$perPage&_embed');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Post> posts = [];

        for (var postJson in jsonData) {
          // Extract author name from embedded data
          String? authorName;
          if (postJson['_embedded'] != null && postJson['_embedded']['author'] != null) {
            final authorData = postJson['_embedded']['author'][0];
            authorName = authorData['name'];
          }

          // Extract featured image from embedded data
          String? featuredImageUrl;
          if (postJson['_embedded'] != null && 
              postJson['_embedded']['wp:featuredmedia'] != null &&
              postJson['_embedded']['wp:featuredmedia'].isNotEmpty) {
            final mediaData = postJson['_embedded']['wp:featuredmedia'][0];
            featuredImageUrl = mediaData['source_url'];
          }

          posts.add(Post.fromJson(
            postJson,
            authorName: authorName,
            featuredImageUrl: featuredImageUrl,
          ));
        }

        return posts;
      } else if (response.statusCode == 400) {
        // No more posts available
        return [];
      } else {
        throw Exception('Failed to load posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching posts: $e');
    }
  }

  /// Fetch a single post by ID
  Future<Post?> fetchPostById(int id) async {
    try {
      final url = Uri.parse('$baseUrl/posts/$id?_embed');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final postJson = json.decode(response.body);
        
        String? authorName;
        if (postJson['_embedded'] != null && postJson['_embedded']['author'] != null) {
          final authorData = postJson['_embedded']['author'][0];
          authorName = authorData['name'];
        }

        String? featuredImageUrl;
        if (postJson['_embedded'] != null && 
            postJson['_embedded']['wp:featuredmedia'] != null &&
            postJson['_embedded']['wp:featuredmedia'].isNotEmpty) {
          final mediaData = postJson['_embedded']['wp:featuredmedia'][0];
          featuredImageUrl = mediaData['source_url'];
        }

        return Post.fromJson(
          postJson,
          authorName: authorName,
          featuredImageUrl: featuredImageUrl,
        );
      } else {
        throw Exception('Failed to load post: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching post: $e');
    }
  }

  /// Search posts by keyword
  Future<List<Post>> searchPosts(String query, {int page = 1, int perPage = 10}) async {
    try {
      final url = Uri.parse('$baseUrl/posts?search=$query&page=$page&per_page=$perPage&_embed');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Post> posts = [];

        for (var postJson in jsonData) {
          String? authorName;
          if (postJson['_embedded'] != null && postJson['_embedded']['author'] != null) {
            final authorData = postJson['_embedded']['author'][0];
            authorName = authorData['name'];
          }

          String? featuredImageUrl;
          if (postJson['_embedded'] != null && 
              postJson['_embedded']['wp:featuredmedia'] != null &&
              postJson['_embedded']['wp:featuredmedia'].isNotEmpty) {
            final mediaData = postJson['_embedded']['wp:featuredmedia'][0];
            featuredImageUrl = mediaData['source_url'];
          }

          posts.add(Post.fromJson(
            postJson,
            authorName: authorName,
            featuredImageUrl: featuredImageUrl,
          ));
        }

        return posts;
      } else if (response.statusCode == 400) {
        return [];
      } else {
        throw Exception('Failed to search posts: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error searching posts: $e');
    }
  }

  /// Fetch all categories
  Future<List<Category>> fetchCategories() async {
    try {
      final url = Uri.parse('$baseUrl/categories?per_page=100');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        return jsonData.map((json) => Category.fromJson(json)).toList();
      } else {
        throw Exception('Failed to load categories: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching categories: $e');
    }
  }

  /// Fetch posts by category
  Future<List<Post>> fetchPostsByCategory(int categoryId, {int page = 1, int perPage = 10}) async {
    try {
      final url = Uri.parse('$baseUrl/posts?categories=$categoryId&page=$page&per_page=$perPage&_embed');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);
        List<Post> posts = [];

        for (var postJson in jsonData) {
          String? authorName;
          if (postJson['_embedded'] != null && postJson['_embedded']['author'] != null) {
            final authorData = postJson['_embedded']['author'][0];
            authorName = authorData['name'];
          }

          String? featuredImageUrl;
          if (postJson['_embedded'] != null && 
              postJson['_embedded']['wp:featuredmedia'] != null &&
              postJson['_embedded']['wp:featuredmedia'].isNotEmpty) {
            final mediaData = postJson['_embedded']['wp:featuredmedia'][0];
            featuredImageUrl = mediaData['source_url'];
          }

          posts.add(Post.fromJson(
            postJson,
            authorName: authorName,
            featuredImageUrl: featuredImageUrl,
          ));
        }

        return posts;
      } else if (response.statusCode == 400) {
        return [];
      } else {
        throw Exception('Failed to load posts by category: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error fetching posts by category: $e');
    }
  }

  /// Fetch author by ID
  Future<Author?> fetchAuthor(int authorId) async {
    // Check cache first
    if (_authorsCache.containsKey(authorId)) {
      return _authorsCache[authorId];
    }

    try {
      final url = Uri.parse('$baseUrl/users/$authorId');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final author = Author.fromJson(json.decode(response.body));
        _authorsCache[authorId] = author;
        return author;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }
}

