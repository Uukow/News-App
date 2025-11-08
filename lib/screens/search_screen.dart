import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/post_provider.dart';
import '../widgets/post_card.dart';
import '../widgets/loading_widget.dart';
import '../widgets/error_widget.dart';
import 'post_detail_screen.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _searchController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<PostProvider>(context, listen: false);
      if (!provider.isLoadingMore && provider.hasMorePosts && provider.isSearching) {
        provider.fetchPosts();
      }
    }
  }

  void _performSearch(String query) {
    if (query.trim().isEmpty) return;
    
    final provider = Provider.of<PostProvider>(context, listen: false);
    provider.searchPosts(query.trim());
  }

  void _clearSearch() {
    _searchController.clear();
    final provider = Provider.of<PostProvider>(context, listen: false);
    provider.clearFilters();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF262262),
        elevation: 0.5,
        shadowColor: Colors.black.withOpacity(0.1),
        title: Container(
          height: 45,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(24),
          ),
          child: TextField(
            controller: _searchController,
            autofocus: true,
            decoration: InputDecoration(
              hintText: 'Search articles...',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.grey[500]),
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              suffixIcon: _searchController.text.isNotEmpty
                  ? IconButton(
                      icon: Icon(Icons.clear, color: Colors.grey[700]),
                      onPressed: _clearSearch,
                    )
                  : null,
            ),
            style: const TextStyle(fontSize: 16, color: Color(0xFF262262)),
            textInputAction: TextInputAction.search,
            onSubmitted: _performSearch,
            onChanged: (value) {
              setState(() {}); // Rebuild to show/hide clear button
            },
          ),
        ),
        actions: [
          Container(
            margin: const EdgeInsets.only(right: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF262262),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.search_rounded, color: Colors.white),
              onPressed: () => _performSearch(_searchController.text),
              tooltip: 'Search',
            ),
          ),
        ],
      ),
      body: Consumer<PostProvider>(
        builder: (context, provider, child) {
          // Initial state with better design
          if (!provider.isSearching && provider.posts.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.search_rounded,
                      size: 80,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Search for Articles',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      'Enter keywords to discover amazing content from Uukow Media',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          // Loading state
          if (provider.isLoading && provider.posts.isEmpty) {
            return const LoadingWidget();
          }

          // Error state
          if (provider.error != null && provider.posts.isEmpty) {
            return ErrorDisplayWidget(
              message: provider.error!,
              onRetry: () => _performSearch(_searchController.text),
            );
          }

          // Empty results with better design
          if (provider.posts.isEmpty && provider.isSearching) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(24),
                    decoration: BoxDecoration(
                      color: Colors.orange.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.search_off_rounded,
                      size: 80,
                      color: Colors.orange,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'No Results Found',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 12),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 48),
                    child: Text(
                      'Try using different keywords or check your spelling',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: Colors.grey[600],
                            height: 1.5,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            );
          }

          // Results list
          return ListView.builder(
            controller: _scrollController,
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: provider.posts.length + (provider.hasMorePosts ? 1 : 0),
            itemBuilder: (context, index) {
              if (index == provider.posts.length) {
                return const Padding(
                  padding: EdgeInsets.all(16.0),
                  child: Center(
                    child: CircularProgressIndicator(),
                  ),
                );
              }

              final post = provider.posts[index];
              return PostCard(
                post: post,
                onTap: () {
                  provider.selectPost(post);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const PostDetailScreen(),
                    ),
                  );
                },
              );
            },
          );
        },
      ),
    );
  }
}

