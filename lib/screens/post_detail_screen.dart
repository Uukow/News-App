import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/flutter_html.dart';
import 'package:intl/intl.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';
import '../providers/post_provider.dart';
import '../utils/html_parser.dart' as utils;

class PostDetailScreen extends StatelessWidget {
  const PostDetailScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<PostProvider>(
      builder: (context, provider, child) {
        final post = provider.selectedPost;

        if (post == null) {
          return Scaffold(
            appBar: AppBar(),
            body: const Center(child: Text('Post not found')),
          );
        }

        final formattedDate = _formatDate(post.date);

        final isDark = Theme.of(context).brightness == Brightness.dark;
        
        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: CustomScrollView(
            slivers: [
              // App Bar with Featured Image
              SliverAppBar(
                expandedHeight: 300,
                pinned: true,
                elevation: 0,
                backgroundColor: Theme.of(context).primaryColor,
                flexibleSpace: FlexibleSpaceBar(
                  background: Stack(
                    fit: StackFit.expand,
                    children: [
                      post.featuredImageUrl != null
                          ? CachedNetworkImage(
                              imageUrl: post.featuredImageUrl!,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).primaryColor,
                                      Theme.of(context).primaryColor.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                                child: const Center(
                                  child: CircularProgressIndicator(color: Colors.white),
                                ),
                              ),
                              errorWidget: (context, url, error) => Container(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).primaryColor,
                                      Theme.of(context).primaryColor.withOpacity(0.7),
                                    ],
                                  ),
                                ),
                                child: const Icon(
                                  Icons.image_not_supported,
                                  size: 60,
                                  color: Colors.white70,
                                ),
                              ),
                            )
                          : Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topLeft,
                                  end: Alignment.bottomRight,
                                  colors: [
                                    Theme.of(context).primaryColor,
                                    Theme.of(context).primaryColor.withOpacity(0.7),
                                  ],
                                ),
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.article_rounded,
                                  size: 80,
                                  color: Colors.white70,
                                ),
                              ),
                            ),
                      // Dark gradient overlay
                      Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                actions: [
                  Container(
                    margin: const EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.3),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.share_rounded, color: Colors.white),
                      onPressed: () => _sharePost(post.title, post.link),
                      tooltip: 'Share',
                    ),
                  ),
                ],
              ),

              // Post Content
              SliverToBoxAdapter(
                child: Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).cardTheme.color,
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Title with better typography
                        Text(
                          utils.HtmlParser.parseHtmlString(post.title),
                          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                                height: 1.3,
                                letterSpacing: -0.5,
                              ),
                        ),
                        const SizedBox(height: 20),

                        // Meta information with modern design
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: isDark ? Colors.grey[900] : Colors.grey[50],
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: isDark ? Colors.grey[800]! : Colors.grey[200]!,
                            ),
                          ),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(3),
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    colors: [
                                      Theme.of(context).primaryColor,
                                      Theme.of(context).primaryColor.withOpacity(0.7),
                                    ],
                                  ),
                                  shape: BoxShape.circle,
                                ),
                                child: CircleAvatar(
                                  radius: 22,
                                  backgroundColor: isDark ? const Color(0xFF2C2C2C) : Colors.white,
                                  child: Text(
                                    post.authorName.isNotEmpty
                                        ? post.authorName[0].toUpperCase()
                                        : 'U',
                                    style: TextStyle(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      post.authorName,
                                      style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                    const SizedBox(height: 4),
                                    Row(
                                      children: [
                                        Icon(Icons.access_time, size: 14, color: Colors.grey[600]),
                                        const SizedBox(width: 4),
                                        Text(
                                          formattedDate,
                                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                                color: Colors.grey[600],
                                              ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 24),

                        // Content with better styling
                        Html(
                          data: post.content,
                          style: {
                            "body": Style(
                              fontSize: FontSize(17),
                              lineHeight: const LineHeight(1.8),
                              color: isDark ? const Color(0xFFE0E0E0) : const Color(0xFF2C3E50),
                            ),
                            "p": Style(
                              margin: Margins.only(bottom: 18),
                            ),
                            "h1": Style(
                              fontSize: FontSize(26),
                              fontWeight: FontWeight.bold,
                              margin: Margins.only(top: 24, bottom: 12),
                            ),
                            "h2": Style(
                              fontSize: FontSize(22),
                              fontWeight: FontWeight.bold,
                              margin: Margins.only(top: 20, bottom: 10),
                            ),
                            "h3": Style(
                              fontSize: FontSize(19),
                              fontWeight: FontWeight.w600,
                              margin: Margins.only(top: 16, bottom: 8),
                            ),
                            "img": Style(
                              width: Width(double.infinity),
                              margin: Margins.symmetric(vertical: 16),
                            ),
                            "a": Style(
                              color: Theme.of(context).primaryColor,
                              textDecoration: TextDecoration.underline,
                              fontWeight: FontWeight.w600,
                            ),
                            "blockquote": Style(
                              border: Border(
                                left: BorderSide(
                                  color: Theme.of(context).primaryColor,
                                  width: 4,
                                ),
                              ),
                              margin: Margins.symmetric(vertical: 16),
                              padding: HtmlPaddings.only(left: 16),
                              backgroundColor: isDark ? Colors.grey[900] : Colors.grey[50],
                            ),
                            "ul": Style(
                              margin: Margins.only(bottom: 16),
                            ),
                            "ol": Style(
                              margin: Margins.only(bottom: 16),
                            ),
                          },
                          onLinkTap: (url, _, __) {
                            if (url != null) {
                              _launchUrl(url);
                            }
                          },
                        ),
                        const SizedBox(height: 32),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  String _formatDate(String dateStr) {
    try {
      final date = DateTime.parse(dateStr);
      return DateFormat('MMMM dd, yyyy').format(date);
    } catch (e) {
      return dateStr;
    }
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }

  void _sharePost(String title, String link) {
    final cleanTitle = utils.HtmlParser.parseHtmlString(title);
    Share.share('$cleanTitle\n\n$link');
  }
}
