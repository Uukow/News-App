import 'package:flutter/material.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: true,
      child: Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF262262),
        elevation: 0.5,
        shadowColor: Colors.black.withOpacity(0.1),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Privacy Policy'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Center(
              child: Column(
                children: [
                  Icon(
                    Icons.privacy_tip,
                    size: 80,
                    color: Theme.of(context).primaryColor,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Privacy Policy',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Last Updated: November 8, 2024',
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),

            // Introduction
            _buildSection(
              context,
              title: '1. Introduction',
              content:
                  'Uukow Media ("we", "our", or "us") is committed to protecting your privacy. This Privacy Policy explains how we collect, use, disclose, and safeguard your information when you use our mobile application.',
            ),

            _buildSection(
              context,
              title: '2. Information We Collect',
              content:
                  'We collect information that you provide directly to us when using our app, including:\n\n'
                  '• Reading preferences and bookmarked articles\n'
                  '• Search history within the app\n'
                  '• Device information (OS version, device model)\n'
                  '• App usage analytics\n'
                  '• Crash reports and performance data',
            ),

            _buildSection(
              context,
              title: '3. How We Use Your Information',
              content:
                  'We use the collected information to:\n\n'
                  '• Provide and improve our services\n'
                  '• Personalize your reading experience\n'
                  '• Send you relevant news updates (with your consent)\n'
                  '• Analyze app usage and performance\n'
                  '• Fix bugs and technical issues\n'
                  '• Ensure security and prevent fraud',
            ),

            _buildSection(
              context,
              title: '4. Data Storage and Security',
              content:
                  'Your data is stored locally on your device using secure encryption methods. We implement appropriate technical and organizational measures to protect your information against unauthorized access, alteration, disclosure, or destruction.',
            ),

            _buildSection(
              context,
              title: '5. Offline Caching',
              content:
                  'Our app stores articles locally on your device for offline reading. This cached data is stored securely and can be cleared at any time from your device settings or by uninstalling the app.',
            ),

            _buildSection(
              context,
              title: '6. Third-Party Services',
              content:
                  'We use third-party services that may collect information used to identify you:\n\n'
                  '• WordPress API for content delivery\n'
                  '• Firebase (optional) for push notifications\n'
                  '• Analytics services for app improvement\n\n'
                  'These services have their own privacy policies and we recommend reviewing them.',
            ),

            _buildSection(
              context,
              title: '7. Cookies and Tracking',
              content:
                  'Our app uses local storage and caching mechanisms to improve performance and user experience. We do not use cookies for tracking purposes.',
            ),

            _buildSection(
              context,
              title: '8. Your Rights',
              content:
                  'You have the right to:\n\n'
                  '• Access your personal data\n'
                  '• Correct inaccurate data\n'
                  '• Delete your data\n'
                  '• Opt-out of notifications\n'
                  '• Withdraw consent at any time\n\n'
                  'To exercise these rights, please contact us using the information provided in the Contact section.',
            ),

            _buildSection(
              context,
              title: '9. Children\'s Privacy',
              content:
                  'Our service is not directed to children under 13. We do not knowingly collect personal information from children under 13. If you are a parent or guardian and believe your child has provided us with personal information, please contact us.',
            ),

            _buildSection(
              context,
              title: '10. Changes to This Policy',
              content:
                  'We may update our Privacy Policy from time to time. We will notify you of any changes by posting the new Privacy Policy in the app and updating the "Last Updated" date.',
            ),

            _buildSection(
              context,
              title: '11. Contact Us',
              content:
                  'If you have any questions about this Privacy Policy, please contact us:\n\n'
                  '• Email: privacy@uukow.com\n'
                  '• Website: www.uukow.com\n'
                  '• Address: Mogadishu, Somalia',
            ),

            const SizedBox(height: 32),

            // Acceptance
            Card(
              elevation: 2,
              color: Theme.of(context).primaryColor.withOpacity(0.1),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Theme.of(context).primaryColor,
                      size: 48,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'By using this app, you agree to our Privacy Policy',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
      ),
    );
  }

  Widget _buildSection(BuildContext context,
      {required String title, required String content}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
          ),
          const SizedBox(height: 12),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
          ),
        ],
      ),
    );
  }
}

