import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/foundation.dart';
import 'wordpress_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Top-level function for background message handling
@pragma('vm:entry-point')
Future<void> firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  debugPrint('Handling a background message: ${message.messageId}');
}

class NotificationService {
  // Lazy initialization - don't access Firebase until after Firebase.initializeApp()
  static FirebaseMessaging? _firebaseMessaging;
  static FirebaseMessaging get firebaseMessaging {
    _firebaseMessaging ??= FirebaseMessaging.instance;
    return _firebaseMessaging!;
  }

  static final FlutterLocalNotificationsPlugin _localNotifications =
      FlutterLocalNotificationsPlugin();

  static const String _lastPostIdKey = 'last_post_id';
  static bool _initialized = false;

  /// Initialize Firebase Messaging and Local Notifications
  static Future<void> initialize() async {
    if (_initialized) return;

    try {
      // Request permission for iOS
      NotificationSettings settings = await firebaseMessaging.requestPermission(
        alert: true,
        badge: true,
        sound: true,
        provisional: false,
      );

      if (settings.authorizationStatus == AuthorizationStatus.authorized) {
        debugPrint('User granted notification permission');
      } else {
        debugPrint('User declined or has not accepted notification permission');
      }

      // Initialize local notifications
      const androidSettings = AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      );
      const iosSettings = DarwinInitializationSettings(
        requestAlertPermission: true,
        requestBadgePermission: true,
        requestSoundPermission: true,
      );

      const initSettings = InitializationSettings(
        android: androidSettings,
        iOS: iosSettings,
      );

      await _localNotifications.initialize(
        initSettings,
        onDidReceiveNotificationResponse: _onNotificationTapped,
      );

      // Create notification channel for Android
      const androidChannel = AndroidNotificationChannel(
        'uukow_posts_channel',
        'New Posts',
        description: 'Notifications for new blog posts from Uukow Media',
        importance: Importance.high,
      );

      await _localNotifications
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(androidChannel);

      // Handle background messages
      FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

      // Handle foreground messages
      FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

      // Handle notification taps when app is in background
      FirebaseMessaging.onMessageOpenedApp.listen(_handleNotificationTap);

      // Get FCM token
      String? token = await firebaseMessaging.getToken();
      debugPrint('FCM Token: $token');

      // Listen for token refresh
      firebaseMessaging.onTokenRefresh.listen((newToken) {
        debugPrint('FCM Token refreshed: $newToken');
        // TODO: Send token to your server if needed
      });

      _initialized = true;
    } catch (e) {
      debugPrint('Error initializing notifications: $e');
    }
  }

  /// Handle foreground messages
  static Future<void> _handleForegroundMessage(RemoteMessage message) async {
    debugPrint('Received foreground message: ${message.messageId}');

    RemoteNotification? notification = message.notification;
    AndroidNotification? android = message.notification?.android;

    if (notification != null && android != null) {
      await _localNotifications.show(
        notification.hashCode,
        notification.title,
        notification.body,
        const NotificationDetails(
          android: AndroidNotificationDetails(
            'uukow_posts_channel',
            'New Posts',
            channelDescription:
                'Notifications for new blog posts from Uukow Media',
            importance: Importance.high,
            priority: Priority.high,
            icon: '@mipmap/ic_launcher',
          ),
          iOS: DarwinNotificationDetails(
            presentAlert: true,
            presentBadge: true,
            presentSound: true,
          ),
        ),
      );
    }
  }

  /// Handle notification tap
  static void _handleNotificationTap(RemoteMessage message) {
    debugPrint('Notification tapped: ${message.messageId}');
    // Navigate to post detail if post ID is provided
    // This will be handled in main.dart
  }

  /// Callback when local notification is tapped
  static void _onNotificationTapped(NotificationResponse response) {
    debugPrint('Notification tapped: ${response.payload}');
    // Handle navigation here
  }

  /// Check for new posts and send local notification
  static Future<void> checkForNewPosts() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final lastPostId = prefs.getInt(_lastPostIdKey) ?? 0;

      final wordPressService = WordPressService();
      final posts = await wordPressService.fetchPosts(page: 1, perPage: 1);

      if (posts.isNotEmpty) {
        final latestPostId = posts.first.id;

        if (latestPostId > lastPostId) {
          // New post found!
          await prefs.setInt(_lastPostIdKey, latestPostId);

          // Show local notification
          await _localNotifications.show(
            latestPostId,
            '📰 New Post on Uukow Media',
            posts.first.title.length > 100
                ? '${posts.first.title.substring(0, 100)}...'
                : posts.first.title,
            const NotificationDetails(
              android: AndroidNotificationDetails(
                'uukow_posts_channel',
                'New Posts',
                channelDescription:
                    'Notifications for new blog posts from Uukow Media',
                importance: Importance.high,
                priority: Priority.high,
                icon: '@mipmap/ic_launcher',
                styleInformation: BigTextStyleInformation(''),
              ),
              iOS: DarwinNotificationDetails(
                presentAlert: true,
                presentBadge: true,
                presentSound: true,
              ),
            ),
            payload: latestPostId.toString(),
          );

          debugPrint('New post notification sent: ${posts.first.title}');
        }
      }
    } catch (e) {
      debugPrint('Error checking for new posts: $e');
    }
  }

  /// Subscribe to topic (optional - for targeting all users)
  static Future<void> subscribeToTopic(String topic) async {
    try {
      await firebaseMessaging.subscribeToTopic(topic);
      debugPrint('Subscribed to topic: $topic');
    } catch (e) {
      debugPrint('Error subscribing to topic: $e');
    }
  }

  /// Unsubscribe from topic
  static Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await firebaseMessaging.unsubscribeFromTopic(topic);
      debugPrint('Unsubscribed from topic: $topic');
    } catch (e) {
      debugPrint('Error unsubscribing from topic: $e');
    }
  }

  /// Get FCM token
  static Future<String?> getToken() async {
    try {
      return await firebaseMessaging.getToken();
    } catch (e) {
      debugPrint('Error getting FCM token: $e');
      return null;
    }
  }
}
