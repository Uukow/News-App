import 'package:flutter/foundation.dart';
import '../models/post_model.dart';
import '../models/category_model.dart' as models;
import '../services/wordpress_service.dart';
import '../services/cache_service.dart';

class PostProvider extends ChangeNotifier {
  final WordPressService _apiService = WordPressService();

  List<Post> _posts = [];
  List<models.Category> _categories = [];
  Post? _selectedPost;
  models.Category? _selectedCategory;

  bool _isLoading = false;
  bool _isLoadingMore = false;
  bool _hasMorePosts = true;
  String? _error;
  int _currentPage = 1;
  String _searchQuery = '';

  // Getters
  List<Post> get posts => _posts;
  List<models.Category> get categories => _categories;
  Post? get selectedPost => _selectedPost;
  models.Category? get selectedCategory => _selectedCategory;
  bool get isLoading => _isLoading;
  bool get isLoadingMore => _isLoadingMore;
  bool get hasMorePosts => _hasMorePosts;
  String? get error => _error;
  bool get isSearching => _searchQuery.isNotEmpty;

  /// Fetch posts with optional refresh
  Future<void> fetchPosts({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _hasMorePosts = true;
      _posts.clear();
      _searchQuery = '';
      _selectedCategory = null;
    }

    // 🚀 OFFLINE-FIRST: Load cache immediately for instant UI
    if (_currentPage == 1 && _posts.isEmpty && 
        _searchQuery.isEmpty && _selectedCategory == null) {
      final cachedPosts = CacheService.getCachedPosts();
      if (cachedPosts.isNotEmpty) {
        _posts = cachedPosts;
        notifyListeners(); // Show cached data instantly!
      }
    }

    if (_isLoading || !_hasMorePosts) return;

    _isLoading = _currentPage == 1;
    _isLoadingMore = _currentPage > 1;
    _error = null;
    notifyListeners();

    try {
      List<Post> newPosts;

      // Check if we have a search query or category filter
      if (_searchQuery.isNotEmpty) {
        newPosts = await _apiService.searchPosts(
          _searchQuery,
          page: _currentPage,
          perPage: 10,
        );
      } else if (_selectedCategory != null) {
        newPosts = await _apiService.fetchPostsByCategory(
          _selectedCategory!.id,
          page: _currentPage,
          perPage: 10,
        );
      } else {
        newPosts = await _apiService.fetchPosts(
          page: _currentPage,
          perPage: 10,
        );
      }

      if (newPosts.isEmpty) {
        _hasMorePosts = false;
      } else {
        // Replace cached data with fresh data on first page
        if (_currentPage == 1 && _searchQuery.isEmpty && _selectedCategory == null) {
          _posts = newPosts;
        } else {
          _posts.addAll(newPosts);
        }
        _currentPage++;

        // Save to cache only if we're on the first page and no filters
        if (_currentPage == 2 &&
            _searchQuery.isEmpty &&
            _selectedCategory == null) {
          await CacheService.savePosts(_posts, clearExisting: true);
        }
      }
      
      // Clear error on successful fetch
      _error = null;
    } catch (e) {
      // If this is the first page and we have cached data, use it
      if (_currentPage == 1) {
        final cachedPosts = CacheService.getCachedPosts();
        if (cachedPosts.isNotEmpty) {
          _posts = cachedPosts;
          _error = 'Showing cached posts'; // Simplified error message
        } else {
          _error = 'Unable to load posts. Please check your internet connection.';
        }
      } else {
        _error = e.toString();
      }
    } finally {
      _isLoading = false;
      _isLoadingMore = false;
      notifyListeners();
    }
  }

  /// Load cached posts
  Future<void> loadCachedPosts() async {
    _isLoading = true;
    notifyListeners();

    try {
      final cachedPosts = CacheService.getCachedPosts();
      if (cachedPosts.isNotEmpty) {
        _posts = cachedPosts;
      }
    } catch (e) {
      _error = 'Failed to load cached posts: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Fetch categories
  Future<void> fetchCategories() async {
    try {
      // Try to get from cache first
      final cachedCategories = CacheService.getCachedCategories();
      if (cachedCategories.isNotEmpty) {
        _categories = cachedCategories;
        notifyListeners();
      }

      // Fetch fresh data
      _categories = await _apiService.fetchCategories();
      await CacheService.saveCategories(_categories);
      notifyListeners();
    } catch (e) {
      // If fetch fails, use cached data if available
      if (_categories.isEmpty) {
        _categories = CacheService.getCachedCategories();
      }
      notifyListeners();
    }
  }

  /// Filter posts by category
  Future<void> filterByCategory(models.Category? category) async {
    _selectedCategory = category;
    _currentPage = 1;
    _posts.clear();
    _hasMorePosts = true;
    _searchQuery = '';
    notifyListeners();

    await fetchPosts();
  }

  /// Search posts
  Future<void> searchPosts(String query) async {
    _searchQuery = query;
    _currentPage = 1;
    _posts.clear();
    _hasMorePosts = true;
    _selectedCategory = null;
    notifyListeners();

    if (query.isEmpty) {
      await fetchPosts();
    } else {
      await fetchPosts();
    }
  }

  /// Select a post for detail view
  void selectPost(Post post) {
    _selectedPost = post;
    notifyListeners();
  }

  /// Clear search and filters
  Future<void> clearFilters() async {
    _searchQuery = '';
    _selectedCategory = null;
    _currentPage = 1;
    _posts.clear();
    _hasMorePosts = true;
    notifyListeners();

    await fetchPosts();
  }

  /// Clear error
  void clearError() {
    _error = null;
    notifyListeners();
  }

  /// Refresh posts (pull-to-refresh)
  Future<void> refreshPosts() async {
    await fetchPosts(refresh: true);
  }
}
