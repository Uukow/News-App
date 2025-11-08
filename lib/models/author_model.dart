class Author {
  final int id;
  final String name;
  final String? description;
  final String? avatarUrl;

  Author({
    required this.id,
    required this.name,
    this.description,
    this.avatarUrl,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    String? avatarUrl;
    if (json['avatar_urls'] != null && json['avatar_urls'] is Map) {
      // Try to get the largest available avatar
      final avatarUrls = json['avatar_urls'] as Map<String, dynamic>;
      avatarUrl = avatarUrls['96'] ?? avatarUrls['48'] ?? avatarUrls['24'];
    }

    return Author(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown Author',
      description: json['description'],
      avatarUrl: avatarUrl,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'avatar_urls': avatarUrl != null ? {'96': avatarUrl} : null,
    };
  }
}

