import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kodonomad/features/feed/screens/feed_screen.dart';
import 'package:kodonomad/features/spots/screens/map_screen.dart';
import 'package:kodonomad/features/marketplace/screens/marketplace_screen.dart';
import 'package:kodonomad/features/forums/screens/forums_screen.dart';
import 'package:kodonomad/features/messages/screens/messages_screen.dart';
import 'package:kodonomad/features/notifications/screens/notifications_screen.dart';
import 'package:kodonomad/features/badges/screens/leaderboard_screen.dart';
import 'package:kodonomad/features/profile/screens/profile_screen.dart';
import 'package:kodonomad/features/nimbus/screens/nimbus_screen.dart';
import 'package:kodonomad/features/events/screens/events_screen.dart';
import 'package:kodonomad/features/challenges/screens/challenges_screen.dart';
import 'package:kodonomad/features/lists/screens/lists_screen.dart';
import 'package:kodonomad/features/recommendations/screens/recommendations_screen.dart';
import 'package:kodonomad/features/search/screens/search_screen.dart';
import 'package:kodonomad/features/static/screens/about_screen.dart';
import 'package:kodonomad/features/static/screens/terms_screen.dart';
import 'package:kodonomad/features/static/screens/legal_screen.dart';
import 'package:kodonomad/features/static/screens/contact_screen.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen();
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  int _selectedIndex = 0;

  static const List<String> _titles = [
    'Feed',
    'Map',
    'Market',
    'Forums',
    'Messages',
    'Events',
    'Challenges',
    'Lists',
    'Recommendations',
    'Explore',
    'Games',
    'Check-Ins',
    'Resources',
    'Notifications',
    'Leaderboard',
    'Profile'
  ];
  static const List<Widget> _screens = [
    FeedScreen(),
    MapScreen(),
    MarketplaceScreen(),
    ForumsScreen(),
    MessagesScreen(receiverId: 2),
    EventsScreen(),
    ChallengesScreen(),
    ListsScreen(),
    RecommendationsScreen(),
    ExploreScreen(),
    GamesScreen(),
    CheckInScreen(),
    ResourcesScreen(),
    NotificationsScreen(),
    LeaderboardScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              showSearch(context: context, delegate: SearchScreen());
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Text(
                'kodonomad',
                style: TextStyle(color: Colors.white, fontSize: 24),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.info),
              title: const Text('About'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const AboutScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.description),
              title: const Text('Terms of Service'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const TermsScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.gavel),
              title: const Text('Legal'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LegalScreen()),
                );
              },
            ),
            ListTile(
              leading: const Icon(Icons.contact_mail),
              title: const Text('Contact'),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ContactScreen()),
                );
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.feed), label: 'Feed'),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: 'Map'),
          BottomNavigationBarItem(icon: Icon(Icons.store), label: 'Market'),
          BottomNavigationBarItem(icon: Icon(Icons.forum), label: 'Forums'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Messages'),
          BottomNavigationBarItem(icon: Icon(Icons.event), label: 'Events'),
          BottomNavigationBarItem(icon: Icon(Icons.star), label: 'Challenges'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'Lists'),
          BottomNavigationBarItem(
              icon: Icon(Icons.recommend), label: 'Recommendations'),
          BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
          BottomNavigationBarItem(icon: Icon(Icons.videogame_asset), label: 'Games'),
          BottomNavigationBarItem(icon: Icon(Icons.check_circle), label: 'Check-Ins'),
          BottomNavigationBarItem(icon: Icon(Icons.handyman), label: 'Resources'),
          BottomNavigationBarItem(
              icon: Icon(Icons.notifications), label: 'Notifications'),
          BottomNavigationBarItem(
              icon: Icon(Icons.leaderboard), label: 'Leaderboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            builder: (context) => Container(
              height: 300,
              child: const NimbusScreen(),
            ),
          );
        },
        child: const Icon(Icons.chat_bubble, color: Colors.white),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
    );
  }
}
