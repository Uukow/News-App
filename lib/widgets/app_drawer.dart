import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../screens/about_screen.dart';
import '../screens/contact_screen.dart';
import '../screens/privacy_policy_screen.dart';
import '../screens/settings_screen.dart';
import '../screens/search_screen.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          // Drawer Header with enhanced design (Fixed height)
          DrawerHeader(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Theme.of(context).scaffoldBackgroundColor,
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.7),
                  Theme.of(context).scaffoldBackgroundColor.withOpacity(0.8),
                ],
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                SizedBox(
                  width: 220,
                  height: 80,
                  child: Image.asset(
                    'assets/logo/logo.png',
                    fit: BoxFit.contain,
                  ),
                ),
                const SizedBox(height: 12),

                const SizedBox(height: 4),
                Text(
                  'Stay Informed, Stay Connected',
                  style: TextStyle(
                    color: Theme.of(context).brightness == Brightness.dark
                        ? Colors.white.withOpacity(0.9)
                        : const Color(0xFF262262).withOpacity(0.8),
                    fontSize: 14,
                    fontWeight: FontWeight.w300,
                  ),
                ),
              ],
            ),
          ),

          // Scrollable menu items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.only(top: 8),
              children: [
                // Home
                _buildDrawerItem(
                  context,
                  icon: Icons.home,
                  title: 'Home',
                  onTap: () {
                    Navigator.of(context).popUntil((route) => route.isFirst);
                  },
                ),

                // Search
                _buildDrawerItem(
                  context,
                  icon: Icons.search,
                  title: 'Search',
                  onTap: () {
                    Navigator.of(context).pop();
                    Future.delayed(const Duration(milliseconds: 250), () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SearchScreen(),
                        ),
                      );
                    });
                  },
                ),

                const Divider(),

                // About
                _buildDrawerItem(
                  context,
                  icon: Icons.info,
                  title: 'About Us',
                  onTap: () {
                    Navigator.of(context).pop();
                    Future.delayed(const Duration(milliseconds: 250), () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const AboutScreen(),
                        ),
                      );
                    });
                  },
                ),

                // Contact
                _buildDrawerItem(
                  context,
                  icon: Icons.contact_mail,
                  title: 'Contact Us',
                  onTap: () {
                    Navigator.of(context).pop();
                    Future.delayed(const Duration(milliseconds: 250), () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const ContactScreen(),
                        ),
                      );
                    });
                  },
                ),

                // Privacy Policy
                _buildDrawerItem(
                  context,
                  icon: Icons.privacy_tip,
                  title: 'Privacy Policy',
                  onTap: () {
                    Navigator.of(context).pop();
                    Future.delayed(const Duration(milliseconds: 250), () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const PrivacyPolicyScreen(),
                        ),
                      );
                    });
                  },
                ),

                const Divider(),

                // Theme Toggle
                Consumer<ThemeProvider>(
                  builder: (context, themeProvider, child) {
                    return _buildDrawerItem(
                      context,
                      icon: themeProvider.isDarkMode
                          ? Icons.dark_mode
                          : Icons.light_mode,
                      title: themeProvider.isDarkMode
                          ? 'Dark Mode'
                          : 'Light Mode',
                      subtitle: 'Tap to switch',
                      onTap: () {
                        themeProvider.toggleTheme();
                      },
                    );
                  },
                ),

                // Settings
                _buildDrawerItem(
                  context,
                  icon: Icons.settings,
                  title: 'Settings',
                  subtitle: 'App preferences',
                  onTap: () {
                    Navigator.of(context).pop();
                    Future.delayed(const Duration(milliseconds: 250), () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) => const SettingsScreen(),
                        ),
                      );
                    });
                  },
                ),

                const Divider(),

                // App Version and Developer Info
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Column(
                    children: [
                      Text(
                        'Version 1.0.0',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'Developed by',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[500],
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Uukow Technology Solutions (Utech)',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontWeight: FontWeight.w600,
                          fontSize: 11,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        '© 2024 Uukow Media',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDrawerItem(
    BuildContext context, {
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor, size: 22),
        ),
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        subtitle: subtitle != null
            ? Text(
                subtitle,
                style: TextStyle(fontSize: 12, color: Colors.grey[600]),
              )
            : null,
        onTap: onTap,
        trailing: Icon(
          Icons.chevron_right_rounded,
          size: 20,
          color: Colors.grey[400],
        ),
      ),
    );
  }
}
