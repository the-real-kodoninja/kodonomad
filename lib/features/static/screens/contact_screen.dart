// lib/features/static/screens/contact_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class ContactScreen extends StatelessWidget {
  const ContactScreen();

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> _launchEmail(String email) async {
    final uri = Uri(scheme: 'mailto', path: email);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Contact Us')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Get in Touch with kodonomad',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'We’re here to support your nomad journey. Reach out to us through the following channels:',
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.email),
              title: const Text('Email Support'),
              subtitle: const Text('contact@kodonomad.social'),
              onTap: () => _launchEmail('contact@kodonomad.social'),
            ),
            ListTile(
              leading: const Icon(Icons.code),
              title: const Text('GitHub Repository'),
              subtitle: const Text('github.com/the-real-kodoninja/kodonomad'),
              onTap: () => _launchUrl('https://github.com/the-real-kodoninja/kodonomad'),
            ),
            ListTile(
              leading: const Icon(Icons.forum),
              title: const Text('Community Forums'),
              subtitle: const Text('Join the discussion on kodonomad'),
              onTap: () {
                // Navigate to ForumsScreen
                Navigator.pushNamed(context, '/forums');
              },
            ),
            const SizedBox(height: 16),
            const Text(
              'For urgent matters, email us directly, and a member of the Kodoverse Collective will respond as soon as possible—whether from a van in Kodocity or a park bench in the real world.',
            ),
          ],
        ),
      ),
    );
  }
}
