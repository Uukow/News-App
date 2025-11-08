import 'package:hive_flutter/hive_flutter.dart';
import '../models/post_model.dart';
import '../models/category_model.dart';

class CacheService {
  static const String postsBoxName = 'posts';
  static const String categoriesBoxName = 'categories';
  static const String metadataBoxName = 'metadata';

  static Box<Post>? _postsBox;
  static Box<Category>? _categoriesBox;
  static Box<dynamic>? _metadataBox;

  /// Initialize Hive and open boxes
  static Future<void> init() async {
    await Hive.initFlutter();

    // Register adapters
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(PostAdapter());
    }
    if (!Hive.isAdapterRegistered(1)) {
      Hive.registerAdapter(CategoryAdapter());
    }

    // Open boxes
    _postsBox = await Hive.openBox<Post>(postsBoxName);
    _categoriesBox = await Hive.openBox<Category>(categoriesBoxName);
    _metadataBox = await Hive.openBox(metadataBoxName);
  }

  /// Save posts to cache
  static Future<void> savePosts(List<Post> posts, {bool clearExisting = false}) async {
    if (_postsBox == null) await init();
    
    if (clearExisting) {
      await _postsBox!.clear();
    }

    for (var post in posts) {
      await _postsBox!.put(post.id, post);
    }

    // Save last update timestamp
    await _metadataBox!.put('posts_last_update', DateTime.now().toIso8601String());
  }

  /// Get all cached posts
  static List<Post> getCachedPosts() {
    if (_postsBox == null) return [];
    return _postsBox!.values.toList();
  }

  /// Get a specific post by ID
  static Post? getCachedPost(int id) {
    if (_postsBox == null) return null;
    return _postsBox!.get(id);
  }

  /// Save categories to cache
  static Future<void> saveCategories(List<Category> categories) async {
    if (_categoriesBox == null) await init();
    
    await _categoriesBox!.clear();
    for (var category in categories) {
      await _categoriesBox!.put(category.id, category);
    }

    await _metadataBox!.put('categories_last_update', DateTime.now().toIso8601String());
  }

  /// Get all cached categories
  static List<Category> getCachedCategories() {
    if (_categoriesBox == null) return [];
    return _categoriesBox!.values.toList();
  }

  /// Check if posts cache is fresh (less than 1 hour old)
  static bool isPostsCacheFresh() {
    if (_metadataBox == null) return false;
    
    final lastUpdateStr = _metadataBox!.get('posts_last_update');
    if (lastUpdateStr == null) return false;

    final lastUpdate = DateTime.parse(lastUpdateStr);
    final difference = DateTime.now().difference(lastUpdate);
    
    return difference.inHours < 1;
  }

  /// Clear all cache
  static Future<void> clearCache() async {
    await _postsBox?.clear();
    await _categoriesBox?.clear();
    await _metadataBox?.clear();
  }

  /// Close all boxes
  static Future<void> close() async {
    await _postsBox?.close();
    await _categoriesBox?.close();
    await _metadataBox?.close();
  }
}

