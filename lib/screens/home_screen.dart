import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import '../providers/post_provider.dart';
import '../models/category_model.dart';
import '../widgets/post_card.dart';
import '../widgets/category_chip.dart';
import '../widgets/error_widget.dart';
import '../widgets/loading_widget.dart';
import '../widgets/app_drawer.dart';
import 'post_detail_screen.dart';
import 'search_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final RefreshController _refreshController = RefreshController(
    initialRefresh: false,
  );
  final ScrollController _scrollController = ScrollController();
  final _advancedDrawerController = AdvancedDrawerController();
  bool _showCategoriesBar = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final provider = Provider.of<PostProvider>(context, listen: false);
      provider.fetchPosts();
      provider.fetchCategories();
    });

    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _refreshController.dispose();
    _scrollController.dispose();
    _advancedDrawerController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      final provider = Provider.of<PostProvider>(context, listen: false);
      if (!provider.isLoadingMore && provider.hasMorePosts) {
        provider.fetchPosts();
      }
    }
  }

  void _onRefresh() async {
    final provider = Provider.of<PostProvider>(context, listen: false);
    await provider.refreshPosts();
    _refreshController.refreshCompleted();
  }

  void _handleMenuButtonPressed() {
    _advancedDrawerController.toggleDrawer();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (bool didPop, dynamic result) async {
        // If drawer is open, close it instead of popping
        if (_advancedDrawerController.value.visible) {
          _advancedDrawerController.hideDrawer();
          return;
        }
        // Otherwise, allow system to handle back (exit app)
        Navigator.of(context).pop();
      },
      child: AdvancedDrawer(
        backdrop: Container(
          width: double.infinity,
          height: double.infinity,
          color: isDark ? const Color(0xFF121212) : Colors.grey[200],
        ),
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        disabledGestures: false,
        childDecoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.3), blurRadius: 15),
          ],
        ),
        drawer: const AppDrawer(),
        child: Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Colors.white,
            foregroundColor: const Color(0xFF262262),
            elevation: 0.5,
            shadowColor: Colors.black.withOpacity(0.1),
            centerTitle: true,
            leading: IconButton(
              icon: ValueListenableBuilder<AdvancedDrawerValue>(
                valueListenable: _advancedDrawerController,
                builder: (_, value, __) {
                  return AnimatedSwitcher(
                    duration: const Duration(milliseconds: 250),
                    child: Icon(
                      value.visible ? Icons.close_rounded : Icons.notes,
                      key: ValueKey<bool>(value.visible),
                    ),
                  );
                },
              ),
              onPressed: _handleMenuButtonPressed,
            ),
            title: SizedBox(
              height: 40,
              child: Image.asset('assets/logo/logo.png', fit: BoxFit.contain),
            ),
            actions: [
              IconButton(
                icon: const Icon(Icons.search_rounded),
                tooltip: 'Search',
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SearchScreen(),
                    ),
                  );
                },
              ),
              IconButton(
                icon: Icon(
                  _showCategoriesBar
                      ? Icons.filter_list_off
                      : Icons.filter_list_rounded,
                ),
                tooltip: _showCategoriesBar
                    ? 'Hide Categories'
                    : 'Show Categories',
                onPressed: () {
                  setState(() {
                    _showCategoriesBar = !_showCategoriesBar;
                  });
                },
              ),
              const SizedBox(width: 4),
            ],
          ),
          body: Column(
            children: [
              // Categories Bar with enhanced design
              if (_showCategoriesBar)
                Consumer<PostProvider>(
                  builder: (context, provider, child) {
                    if (provider.categories.isEmpty) {
                      return const SizedBox.shrink();
                    }

                    return Container(
                      decoration: BoxDecoration(
                        color: Theme.of(context).cardTheme.color,
                        boxShadow: [
                          BoxShadow(
                            color: isDark
                                ? Colors.black.withOpacity(0.3)
                                : Colors.black.withOpacity(0.05),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                            child: Text(
                              'Categories',
                              style: Theme.of(context).textTheme.titleSmall
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.grey[700],
                                  ),
                            ),
                          ),
                          SizedBox(
                            height: 52,
                            child: ListView.builder(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              itemCount: provider.categories.length + 1,
                              itemBuilder: (context, index) {
                                if (index == 0) {
                                  // "All" chip
                                  return CategoryChip(
                                    category: provider.categories[0].copyWith(
                                      id: 0,
                                      name: 'All',
                                    ),
                                    isSelected:
                                        provider.selectedCategory == null,
                                    onTap: () =>
                                        provider.filterByCategory(null),
                                  );
                                }

                                final category = provider.categories[index - 1];
                                return CategoryChip(
                                  category: category,
                                  isSelected:
                                      provider.selectedCategory?.id ==
                                      category.id,
                                  onTap: () =>
                                      provider.filterByCategory(category),
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ),
                    );
                  },
                ),

              // Offline Indicator
              Consumer<PostProvider>(
                builder: (context, provider, child) {
                  // Show offline banner if error contains "cached"
                  if (provider.error != null &&
                      provider.error!.toLowerCase().contains('cached')) {
                    return Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                        vertical: 10,
                        horizontal: 16,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        border: Border(
                          bottom: BorderSide(
                            color: Colors.orange.shade200,
                            width: 1,
                          ),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.cloud_off_rounded,
                            size: 18,
                            color: Colors.orange.shade700,
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'You\'re offline • Showing saved articles',
                              style: TextStyle(
                                color: Colors.orange.shade800,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                          Icon(
                            Icons.offline_bolt,
                            size: 16,
                            color: Colors.orange.shade600,
                          ),
                        ],
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),

              // Posts List
              Expanded(
                child: Consumer<PostProvider>(
                  builder: (context, provider, child) {
                    // Loading state (first page)
                    if (provider.isLoading && provider.posts.isEmpty) {
                      return const LoadingWidget();
                    }

                    // Error state with no posts
                    if (provider.error != null && provider.posts.isEmpty) {
                      return ErrorDisplayWidget(
                        message: provider.error!,
                        onRetry: () => provider.fetchPosts(refresh: true),
                      );
                    }

                    // Empty state
                    if (provider.posts.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.article_outlined,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No posts found',
                              style: Theme.of(context).textTheme.titleLarge,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Check back later for new content',
                              style: Theme.of(context).textTheme.bodyMedium
                                  ?.copyWith(color: Colors.grey[600]),
                            ),
                          ],
                        ),
                      );
                    }

                    // Posts list with pull-to-refresh
                    return SmartRefresher(
                      controller: _refreshController,
                      onRefresh: _onRefresh,
                      enablePullUp: false,
                      header: const WaterDropMaterialHeader(),
                      child: ListView.builder(
                        controller: _scrollController,
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        itemCount:
                            provider.posts.length +
                            (provider.hasMorePosts ? 1 : 0),
                        itemBuilder: (context, index) {
                          if (index == provider.posts.length) {
                            // Loading indicator at the bottom
                            return const Padding(
                              padding: EdgeInsets.all(16.0),
                              child: Center(child: CircularProgressIndicator()),
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
                                  builder: (context) =>
                                      const PostDetailScreen(),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Extension to copy Category with new values
extension CategoryCopyWith on Category {
  Category copyWith({int? id, String? name, String? slug, int? count}) {
    return Category(
      id: id ?? this.id,
      name: name ?? this.name,
      slug: slug ?? this.slug,
      count: count ?? this.count,
    );
  }
}
