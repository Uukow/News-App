import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/cache_service.dart';
import 'services/notification_service.dart';
// import 'services/background_service.dart'; // Temporarily disabled - workmanager compatibility issue
import 'providers/post_provider.dart';
import 'providers/theme_provider.dart';
import 'screens/home_screen.dart';
import 'firebase_options.dart';
import 'utils/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase with proper error handling
  try {
    if (Firebase.apps.isEmpty) {
      await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform,
      );
      debugPrint('✅ Firebase initialized successfully');
    } else {
      debugPrint(
        '⚠️ Firebase already initialized with ${Firebase.apps.length} app(s)',
      );
    }
  } catch (e) {
    if (e.toString().contains('duplicate-app')) {
      debugPrint(
        '⚠️ Firebase duplicate initialization caught: ${e.toString()}',
      );
      // Continue anyway - Firebase is already initialized
    } else {
      debugPrint('❌ Firebase initialization error: $e');
      rethrow;
    }
  }

  // Initialize cache service (Hive)
  await CacheService.init();

  // Initialize notification service
  await NotificationService.initialize();

  // Subscribe to 'new_posts' topic for all users
  await NotificationService.subscribeToTopic('new_posts');

  // Initialize background service for periodic checks
  // TODO: Re-enable when workmanager is updated for Flutter 3.x
  // await BackgroundService.initialize();
  // await BackgroundService.registerPeriodicTask();

  // Set system UI overlay style
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const UukowMediaApp());
}

class UukowMediaApp extends StatelessWidget {
  const UukowMediaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => PostProvider()),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
      ],
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MaterialApp(
            title: 'Uukow Media',
            debugShowCheckedModeBanner: false,
            themeMode: themeProvider.themeMode,
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            home: const SplashScreen(),
          );
        },
      ),
    );
  }
}

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigateToHome();
  }

  Future<void> _navigateToHome() async {
    // Show splash for 2 seconds
    await Future.delayed(const Duration(seconds: 2));

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomeScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              const Color.fromARGB(255, 255, 255, 255),
              const Color.fromARGB(255, 255, 255, 255).withOpacity(0.8),
              const Color.fromARGB(255, 255, 255, 255).withOpacity(0.3),
            ],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Animated Logo
                TweenAnimationBuilder(
                  tween: Tween<double>(begin: 0, end: 1),
                  duration: const Duration(milliseconds: 800),
                  builder: (context, double value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value,
                        child: SizedBox(
                          width: 150,
                          height: 150,
                          child: Image.asset(
                            'assets/logo/logo.png',
                            fit: BoxFit.contain,
                          ),
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 32),
                Text(
                  'Uukow Media',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF262262),
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1,
                    shadows: [
                      Shadow(
                        offset: const Offset(0, 2),
                        blurRadius: 8,
                        color: Colors.black.withOpacity(0.3),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Stay Informed, Stay Connected',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF262262).withOpacity(0.9),
                    fontSize: 16,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 48),
                Text(
                  'Developed by Utech',
                  style: GoogleFonts.poppins(
                    color: const Color(0xFF262262).withOpacity(0.7),
                    fontSize: 13,
                    fontStyle: FontStyle.italic,
                    fontWeight: FontWeight.w300,
                  ),
                ),
                const SizedBox(height: 32),
                const SizedBox(
                  width: 40,
                  height: 40,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation<Color>(
                      const Color(0xFF262262),
                    ),
                    strokeWidth: 3,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
