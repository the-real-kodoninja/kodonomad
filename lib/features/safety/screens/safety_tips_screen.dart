// lib/features/safety/screens/safety_tips_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SafetyTipsScreen extends StatelessWidget {
  const SafetyTipsScreen();

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Nomad Safety Tips')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Stay Safe on the Road',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Emergency Contacts',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.phone),
              title: const Text('Global Emergency Numbers'),
              subtitle: const Text('Access emergency numbers worldwide.'),
              onTap: () => _launchUrl('https://www.countrycode.org/emergency-numbers'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Self-Defense Resources',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(Icons.videocam),
              title: const Text('Basic Self-Defense Tutorials'),
              subtitle: const Text('Learn basic moves to stay safe.'),
              onTap: () => _launchUrl('https://www.youtube.com/results?search_query=basic+self+defense+for+travelers'),
            ),
            const SizedBox(height: 16),
            const Text(
              'Safety Tips',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '- Always share your location with a trusted friend when stealth camping.\n'
              '- Use a VPN (like NordVPN) to secure your internet connection.\n'
              '- Carry a portable alarm or whistle for emergencies.\n'
              '- Trust your instincts—if a spot feels unsafe, move on.',
            ),
          ],
        ),
      ),
    );
  }
}
