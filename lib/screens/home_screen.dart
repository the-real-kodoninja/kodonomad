import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/feed/screens/feed_screen.dart';
import '../features/spots/screens/map_screen.dart';
import '../features/marketplace/screens/marketplace_screen.dart';
import '../features/forums/screens/forums_screen.dart';
import '../features/messages/screens/messages_screen.dart';
import '../features/notifications/screens/notifications_screen.dart';
import '../features/badges/screens/leaderboard_screen.dart';
import '../features/profile/screens/profile_screen.dart';
import '../features/nimbus/screens/nimbus_screen.dart';
import '../features/events/screens/events_screen.dart';
import '../features/challenges/screens/challenges_screen.dart';
import '../features/lists/screens/lists_screen.dart';
import '../features/recommendations/screens/recommendations_screen.dart';
import '../features/search/screens/search_screen.dart'; 

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
