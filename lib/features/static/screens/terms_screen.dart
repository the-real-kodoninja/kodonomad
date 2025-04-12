// lib/features/static/screens/terms_screen.dart
import 'package:flutter/material.dart';

class TermsScreen extends StatelessWidget {
  const TermsScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Terms of Service')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Terms of Service for kodonomad',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Last Updated: April 12, 2025',
              style: TextStyle(fontStyle: FontStyle.italic),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Acceptance of Terms',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'By using kodonomad, you agree to these Terms of Service. If you do not agree, please do not use the app. We reserve the right to update these terms at any time, and continued use constitutes acceptance of the updated terms.',
            ),
            const SizedBox(height: 16),
            const Text(
              '2. User Conduct',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'As a nomad in our community, you agree to:'
              '\n- Share accurate information about spots, trades, and experiences.'
              '\n- Respect other nomads—no harassment, scams, or illegal activities.'
              '\n- Use KodoCoins responsibly within the Kodoverse economy.'
              '\nFailure to comply may result in account suspension or termination.',
            ),
            const SizedBox(height: 16),
            const Text(
              '3. Content Ownership',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'You retain ownership of the content you post (recipes, photos, reviews), but grant kodonomad a non-exclusive, royalty-free license to display and distribute it within the app and Kodoverse platforms.',
            ),
            const SizedBox(height: 16),
            const Text(
              '4. Safety and Liability',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'kodonomad provides tools like maps, safety hacks, and community reviews to help you thrive. However, you use these at your own risk. We are not liable for any incidents, injuries, or losses resulting from your nomad activities.',
            ),
            const SizedBox(height: 16),
            const Text(
              '5. Monetization',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'You may earn through affiliates, subscriptions, or donations within kodonomad. We take a 10% commission on earnings to support the platform. All transactions involving KodoCoins are subject to Kodoverse regulations.',
            ),
          ],
        ),
      ),
    );
  }
}
