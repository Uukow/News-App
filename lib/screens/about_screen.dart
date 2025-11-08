import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen({Key? key}) : super(key: key);

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
          title: const Text('About Us'),
        ),
        body: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Logo/Header
              Center(
                child: Column(
                  children: [
                    SizedBox(
                      width: 120,
                      height: 120,
                      child: Image.asset(
                        'assets/logo/icon.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Uukow Media',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Stay Informed, Stay Connected',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // About Section
              _buildSectionTitle(context, 'Who We Are'),
              const SizedBox(height: 12),
              Text(
                'Uukow Media is a leading digital news platform dedicated to delivering accurate, timely, and engaging content to our readers. We cover a wide range of topics including news, technology, lifestyle, business, and more.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Mission Section
              _buildSectionTitle(context, 'Our Mission'),
              const SizedBox(height: 12),
              Text(
                'Our mission is to provide high-quality journalism that informs, educates, and empowers our community. We believe in the power of storytelling and the importance of keeping our audience connected to the world around them.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 24),

              // Values Section
              _buildSectionTitle(context, 'Our Values'),
              const SizedBox(height: 12),
              _buildValueItem(
                context,
                Icons.verified,
                'Integrity',
                'We uphold the highest standards of journalistic integrity and ethics.',
              ),
              const SizedBox(height: 12),
              _buildValueItem(
                context,
                Icons.people,
                'Community',
                'We serve our community with dedication and respect.',
              ),
              const SizedBox(height: 12),
              _buildValueItem(
                context,
                Icons.lightbulb,
                'Innovation',
                'We embrace innovation to deliver content in engaging ways.',
              ),
              const SizedBox(height: 12),
              _buildValueItem(
                context,
                Icons.balance,
                'Fairness',
                'We strive for balanced and unbiased reporting.',
              ),
              const SizedBox(height: 32),

              // App Version
              _buildSectionTitle(context, 'App Information'),
              const SizedBox(height: 12),
              _buildInfoRow(context, 'Version', '1.0.0'),
              _buildInfoRow(context, 'Platform', 'Android & iOS'),
              _buildInfoRow(context, 'Model', 'All Model'),
              const SizedBox(height: 32),

              // Visit Website Button
              Center(
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.7,
                  child: ElevatedButton.icon(
                    onPressed: () => _launchUrl('https://uukowtech.com'),
                    icon: const Icon(Icons.language),
                    label: const Text('Visit Our Website'),
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 14,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),

              // Developer Info
              Center(
                child: Column(
                  children: [
                    Text(
                      'Developed by',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Uukow Technology Solutions',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColor,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '(Utech)',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '© 2025 Uukow Media. All rights reserved.',
                      style: Theme.of(
                        context,
                      ).textTheme.bodySmall?.copyWith(color: Colors.grey[600]),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
        fontWeight: FontWeight.bold,
        color: Theme.of(context).primaryColor,
      ),
    );
  }

  Widget _buildValueItem(
    BuildContext context,
    IconData icon,
    String title,
    String description,
  ) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: Theme.of(
                  context,
                ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 4),
              Text(
                description,
                style: Theme.of(
                  context,
                ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(BuildContext context, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(
            value,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(color: Colors.grey[700]),
          ),
        ],
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    final url = Uri.parse(urlString);
    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    }
  }
}
