# Uukow Media - Flutter Blog Reader App

A beautiful and feature-rich Flutter mobile application for reading blog posts from [uukow.com](https://uukow.com). The app uses the WordPress REST API to fetch and display articles with offline caching support.

![Flutter](https://img.shields.io/badge/Flutter-02569B?style=for-the-badge&logo=flutter&logoColor=white)
![Dart](https://img.shields.io/badge/Dart-0175C2?style=for-the-badge&logo=dart&logoColor=white)

## ✨ Features

### Core Features
- 📱 **Cross-platform**: Works on both Android and iOS
- 🌐 **WordPress REST API Integration**: Fetches posts, categories, and authors from uukow.com
- 📖 **Beautiful UI**: Modern, clean interface with Material Design 3
- 🎨 **Uukow Branding**: Custom color scheme and splash screen

### Advanced Features
- 📄 **Pagination**: Load posts 10 at a time for better performance
- 🔄 **Pull-to-Refresh**: Swipe down to refresh the feed
- 💾 **Offline Caching**: Read posts offline with Hive local database
- 🔍 **Search Functionality**: Search posts by keywords
- 🏷️ **Category Filtering**: Filter posts by categories
- ❌ **Error Handling**: Graceful error messages and retry options
- 🖼️ **Image Caching**: Fast image loading with cached_network_image
- 📝 **HTML Rendering**: Beautiful post content rendering
- 🔗 **External Links**: Open links in external browser
- 📤 **Share Posts**: Share articles with others

## 🏗️ Architecture

The app follows **MVVM (Model-View-ViewModel)** architecture with **Provider** for state management:

```
lib/
├── models/           # Data models (Post, Category, Author)
├── services/         # API and Cache services
├── providers/        # State management (Provider)
├── screens/          # UI screens
├── widgets/          # Reusable UI components
├── utils/            # Helper functions
└── main.dart         # App entry point
```

### Key Components

1. **Models**: Data structures for Post, Category, and Author
2. **Services**: 
   - `WordPressService`: Handles all API calls to WordPress REST API
   - `CacheService`: Manages offline storage with Hive
3. **Providers**: 
   - `PostProvider`: Manages posts state, pagination, search, and categories
4. **Screens**:
   - `HomeScreen`: Main feed with posts list
   - `PostDetailScreen`: Full post view
   - `SearchScreen`: Search functionality
5. **Widgets**: Reusable components like PostCard, CategoryChip, etc.

## 📦 Dependencies

```yaml
dependencies:
  http: ^1.1.0                          # API requests
  provider: ^6.1.1                      # State management
  hive: ^2.2.3                          # Local database
  hive_flutter: ^1.1.0                  # Hive Flutter support
  cached_network_image: ^3.3.0          # Image caching
  flutter_html: ^3.0.0-beta.2           # HTML rendering
  html: ^0.15.4                         # HTML parsing
  intl: ^0.19.0                         # Date formatting
  url_launcher: ^6.2.2                  # External links
  shared_preferences: ^2.2.2            # Simple data storage
  pull_to_refresh: ^2.0.0               # Pull to refresh
  shimmer: ^3.0.0                       # Loading animations
  share_plus: ^7.2.1                    # Share functionality
```

## 🚀 Getting Started

### Prerequisites

- Flutter SDK (3.9.2 or higher)
- Dart SDK (3.9.2 or higher)
- Android Studio / VS Code
- Xcode (for iOS development)

### Installation

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd uukowmedia
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter pub run build_runner build --delete-conflicting-outputs
   ```

4. **Run the app**
   
   For Android:
   ```bash
   flutter run
   ```
   
   For iOS:
   ```bash
   flutter run
   ```

### Building for Production

#### Android APK
```bash
flutter build apk --release
```
The APK will be available at: `build/app/outputs/flutter-apk/app-release.apk`

#### Android App Bundle (for Google Play)
```bash
flutter build appbundle --release
```

#### iOS IPA
```bash
flutter build ios --release
```
Then use Xcode to archive and export the IPA.

## 📱 Screens

### 1. Home Screen
- Displays a list of posts with featured images
- Pull-to-refresh functionality
- Infinite scroll with pagination
- Category filter toggle
- Search button in app bar

### 2. Post Detail Screen
- Full post content with HTML rendering
- Featured image header
- Author information
- Share button
- Beautiful typography

### 3. Search Screen
- Real-time search
- Search results with same card layout
- Empty state for no results
- Clear search button

## 🎨 Customization

### Colors
The app uses Uukow Media brand colors defined in `main.dart`:

```dart
primaryColor: Color(0xFF1E88E5),      // Blue
secondaryColor: Color(0xFF43A047),    // Green
```

### Logo
Replace the placeholder logo in the splash screen (line 172 in `main.dart`) with your actual logo asset.

### API Endpoint
The WordPress API endpoint is defined in `lib/services/wordpress_service.dart`:

```dart
static const String baseUrl = 'https://uukow.com/wp-json/wp/v2';
```

## 🔧 Configuration

### Android Configuration

1. Update `android/app/src/main/AndroidManifest.xml`:
   - App name
   - Permissions (already included: Internet)

2. Update `android/app/build.gradle.kts`:
   - Application ID
   - Version code and name

### iOS Configuration

1. Update `ios/Runner/Info.plist`:
   - App name
   - Bundle identifier
   - Permissions

## 🧪 Testing

Run tests with:
```bash
flutter test
```

## 📝 API Endpoints Used

- **Posts**: `GET /wp-json/wp/v2/posts`
- **Single Post**: `GET /wp-json/wp/v2/posts/{id}`
- **Categories**: `GET /wp-json/wp/v2/categories`
- **Search**: `GET /wp-json/wp/v2/posts?search={query}`
- **Filter by Category**: `GET /wp-json/wp/v2/posts?categories={id}`

### Query Parameters
- `page`: Page number for pagination
- `per_page`: Number of posts per page (default: 10)
- `_embed`: Include embedded resources (author, featured image)
- `search`: Search query
- `categories`: Category ID for filtering

## 🔐 Permissions

### Android
- `INTERNET`: Required for API calls
- `ACCESS_NETWORK_STATE`: Check network connectivity

### iOS
- `NSAppTransportSecurity`: Configured for HTTP requests

## 📊 Performance

- **Image Caching**: Images are cached using `cached_network_image`
- **Offline Support**: Posts are stored locally using Hive
- **Lazy Loading**: Posts are loaded 10 at a time
- **Efficient Rendering**: Uses ListView.builder for efficient list rendering

## 🐛 Known Issues

- None at the moment

## 🚧 Future Enhancements

- [ ] Firebase push notifications for new posts
- [ ] Bookmarks/Favorites functionality
- [ ] Dark mode support
- [ ] Comments section
- [ ] Social media sharing with preview
- [ ] Multi-language support
- [ ] Reading progress indicator
- [ ] Font size customization

## 📄 License

This project is licensed under the MIT License.

## 👥 Contributors

- Abdulkadir Uukow
- Fardowsa Sheik Abdirahman

## 📞 Support

For issues, questions, or contributions, please:
- Open an issue on GitHub
- Contact: [your-email@example.com]
- Visit: [https://uukow.com](https://uukow.com)

## 🙏 Acknowledgments

- WordPress REST API
- Flutter community
- All open-source package contributors

---

**Made with ❤️ for Uukow Technology Solutions UTECH**
