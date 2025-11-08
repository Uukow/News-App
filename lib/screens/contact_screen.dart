import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen({Key? key}) : super(key: key);

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
          title: const Text('Contact Us'),
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
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Image.asset(
                        'assets/logo/icon.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Get in Touch',
                      style: Theme.of(context).textTheme.headlineMedium
                          ?.copyWith(fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'We\'d love to hear from you!',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyLarge?.copyWith(color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Contact Methods
              _buildContactCard(
                context,
                icon: Icons.email,
                title: 'Email',
                subtitle: 'info@uukowtech.com',
                onTap: () => _launchEmail('info@uukowtech.com'),
              ),
              const SizedBox(height: 16),

              _buildContactCard(
                context,
                icon: Icons.phone,
                title: 'Phone',
                subtitle: '+252 61 388 8976',
                onTap: () => _launchPhone('+252613888976'),
              ),
              const SizedBox(height: 16),

              _buildContactCard(
                context,
                icon: Icons.language,
                title: 'Website',
                subtitle: 'www.uukowtech.com',
                onTap: () => _launchUrl('https://uukowtech.com'),
              ),
              const SizedBox(height: 16),

              _buildContactCard(
                context,
                icon: Icons.location_on,
                title: 'Address',
                subtitle: 'Mogadishu, Somalia',
                onTap: null,
              ),
              const SizedBox(height: 32),

              // Social Media Section
              Text(
                'Follow Us',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              Wrap(
                alignment: WrapAlignment.center,
                spacing: 24,
                runSpacing: 16,
                children: [
                  _buildSocialButton(
                    context,
                    icon: Icons.facebook,
                    label: 'Facebook',
                    color: const Color(0xFF1877F2),
                    onTap: () => _launchUrl('https://facebook.com/uukowtech'),
                  ),
                  _buildSocialButton(
                    context,
                    icon: Icons.telegram,
                    label: 'Twitter',
                    color: const Color(0xFF1DA1F2),
                    onTap: () => _launchUrl('https://twitter.com/uukowtech'),
                  ),
                  _buildSocialButton(
                    context,
                    icon: Icons.link,
                    label: 'Instagram',
                    color: const Color(0xFFE4405F),
                    onTap: () => _launchUrl('https://instagram.com/uukowtech'),
                  ),
                  _buildSocialButton(
                    context,
                    icon: Icons.link,
                    label: 'Telegram',
                    color: const Color.fromARGB(255, 0, 93, 231),
                    onTap: () => _launchUrl('https://t.me/XikmadoSom'),
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Office Hours
              Text(
                'Office Hours',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(height: 16),

              _buildOfficeHoursItem(
                context,
                'Monday - Friday',
                '8:00 AM - 5:00 PM',
              ),
              _buildOfficeHoursItem(context, '24/7', 'Available'),
              _buildOfficeHoursItem(context, '24/7', 'Available for Support'),
              const SizedBox(height: 32),

              // Feedback Section
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.feedback,
                            color: Theme.of(context).primaryColor,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            'Send Feedback',
                            style: Theme.of(context).textTheme.titleMedium
                                ?.copyWith(fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Text(
                        'Have a suggestion or found a bug? We\'d love to hear from you! Send us your feedback and help us improve.',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: () => _launchEmail(
                            'info@uukowtech.com',
                            subject: 'App Feedback',
                          ),
                          icon: const Icon(Icons.send),
                          label: const Text('Send Feedback'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildContactCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    return Card(
      elevation: 2,
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: Theme.of(context).primaryColor),
        ),
        title: Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
        subtitle: Text(subtitle),
        trailing: onTap != null
            ? Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey[400])
            : null,
        onTap: onTap,
      ),
    );
  }

  Widget _buildSocialButton(
    BuildContext context, {
    required IconData icon,
    required String label,
    required Color color,
    required VoidCallback onTap,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: color.withOpacity(0.3),
                  blurRadius: 8,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(icon, color: Colors.white, size: 28),
          ),
        ),
        const SizedBox(height: 8),
        Text(label, style: Theme.of(context).textTheme.bodySmall),
      ],
    );
  }

  Widget _buildOfficeHoursItem(BuildContext context, String day, String hours) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: Theme.of(
              context,
            ).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w600),
          ),
          Text(
            hours,
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

  Future<void> _launchEmail(String email, {String? subject}) async {
    final url = Uri.parse(
      'mailto:$email${subject != null ? '?subject=$subject' : ''}',
    );
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }

  Future<void> _launchPhone(String phone) async {
    final url = Uri.parse('tel:$phone');
    if (await canLaunchUrl(url)) {
      await launchUrl(url);
    }
  }
}
