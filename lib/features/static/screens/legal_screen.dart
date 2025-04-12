// lib/features/static/screens/legal_screen.dart
import 'package:flutter/material.dart';

class LegalScreen extends StatelessWidget {
  const LegalScreen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Legal Information')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Legal Information for kodonomad',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              '1. Privacy Policy',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your privacy is our priority. We collect minimal data:'
              '\n- Profile info (username, photos, nomad type) to personalize your experience.'
              '\n- Encrypted location data for maps and check-ins, never shared with others.'
              '\n- Usage data to improve the app.'
              '\nWe do not sell your data. All location data is encrypted using AES-256.',
            ),
            const SizedBox(height: 16),
            const Text(
              '2. Intellectual Property',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'kodonomad, the Kodoverse, and related assets (logos, KodoCoins) are property of the Kodoverse Collective, founded by Emmanuel Barry Moore. Unauthorized use is prohibited.',
            ),
            const SizedBox(height: 16),
            const Text(
              '3. Dispute Resolution',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Any disputes arising from your use of kodonomad will be resolved through arbitration in accordance with the laws of the Kodoverse Collective, headquartered in Kodocity.',
            ),
            const SizedBox(height: 16),
            const Text(
              '4. Disclaimer',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'kodonomad is provided “as is.” We make no warranties regarding the accuracy of maps, safety tips, or community reviews. Use at your own risk.',
            ),
          ],
        ),
      ),
    );
  }
}
