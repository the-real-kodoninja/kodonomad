// lib/features/resources/screens/resources_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:kodonomad/features/safety/screens/safety_tips_screen.dart';

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen();

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Resources for Nomads')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          const Text(
            'Essential Tools for Nomads',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          ListTile(
            leading: const Icon(Icons.health_and_safety),
            title: const Text('SafetyWing Nomad Insurance'),
            subtitle: const Text('Travel insurance tailored for nomads.'),
            onTap: () => _launchUrl('https://safetywing.com/nomad-insurance'),
          ),
          ListTile(
            leading: const Icon(Icons.vpn_key),
            title: const Text('NordVPN'),
            subtitle: const Text('Secure your connection while on the road.'),
            onTap: () => _launchUrl('https://nordvpn.com'),
          ),
          ListTile(
            leading: const Icon(Icons.wifi),
            title: const Text('WiFi Map'),
            subtitle: const Text('Find free Wi-Fi spots worldwide.'),
            onTap: () => _launchUrl('https://wifimap.io'),
          ),
          ListTile(
            leading: const Icon(Icons.security),
            title: const Text('Nomad Safety Tips'),
            subtitle: const Text('Stay safe with emergency contacts and self-defense resources.'),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SafetyTipsScreen()),
            ),
          ),
        ],
      ),
    );
  }
}
