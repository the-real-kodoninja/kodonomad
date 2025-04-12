// lib/features/static/screens/about_screen.dart
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutScreen extends StatelessWidget {
  const AboutScreen();

  Future<void> _launchUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('About kodonomad')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'kodonomad 🗺️🌍: The Ultimate Nomad Social Network',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Welcome to kodonomad, a cross-platform haven for nomads—backpackers, van lifers, digital wanderers, and every soul chasing freedom on the open road or hidden trail. Built with Flutter and Dart, hosted at github.com/the-real-kodoninja/kodonomad, this isn’t just an app—it’s a thriving social network where nomads connect, collaborate, and conquer the challenges of a rootless life.',
            ),
            const SizedBox(height: 16),
            const Text(
              'Our Vision',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'kodonomad is more than a tool; it’s a community where nomads share safe spots, trade gear, cook fireside meals, and plan van meets—all while dodging the “knock” or scoring free Wi-Fi. It’s where freedom meets connection, and every journey fuels the next.',
            ),
            const SizedBox(height: 16),
            const Text(
              'The Story of kodonomad',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'In the Kodoverse’s sprawling chaos, a lone wanderer emerged: Emmanuel Barry Moore, a nomad forged by Earth’s trails and Kodocity’s shadows. As a boy, he fished Maryland’s rivers, biked to hidden trails, and scaled cliffs with a Kindle glowing in the dusk. By 2016, he traded stability for a suitcase and a backpack, crossing to San Francisco’s wild edge—sleeping under stars, showering in gyms, coding the Kodoverse from library benches and park tables.',
            ),
            const SizedBox(height: 8),
            const Text(
              'Emmanuel’s journey birthed kodonomad—a beacon for Kodoplanet’s nomads and Earth’s roamers alike. Nomads flocked—sharing recipes cooked on van stoves, marking safe trails with virtual dots, trading bikes for Starlink kits. kodonomad became a Kodoverse lifeline—a social nexus where every nomad’s tale wove into a saga of freedom, survival, and the open road.',
            ),
            const SizedBox(height: 16),
            const Text(
              'About the Founder',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              '“As a kid, I fished with live bait, biked to trails, and climbed cliffs with my Kindle. In 2016, I went full nomad—suitcase and backpack to California. I slept outside, showered at gyms, coded in parks, and built the Kodoverse while dodging the ‘knock.’ This app is for us—nomads who thrive free. Check my book, Terrorism & Conspiracy of a Homeless Developer, for the full tale.” — Emmanuel Barry Moore',
            ),
            const SizedBox(height: 8),
            GestureDetector(
              onTap: () => _launchUrl('https://github.com/the-real-kodoninja'),
              child: const Text(
                'github.com/the-real-kodoninja',
                style: TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
