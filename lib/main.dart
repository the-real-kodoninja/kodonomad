import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_ANON_KEY',
  );
  runApp(ProviderScope(child: KodonomadApp()));
}

class KodonomadApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'kodonomad',
      theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Color(0xFF4A704A), // Forest Green
        scaffoldBackgroundColor: Color(0xFFF5E8D3), // Light Sandstone
        colorScheme: ColorScheme.light(
          primary: Color(0xFF4A704A), // Forest Green
          secondary: Color(0xFFA87C5A), // Warm Terracotta
          surface: Color(0xFFF5E8D3), // Light Sandstone
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFF5C4033)), // Rich Earth Brown
          bodyMedium: TextStyle(color: Color(0xFF5C4033)),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF4A704A), // Forest Green
          foregroundColor: Color(0xFFF5E8D3), // Light Sandstone
        ),
        cardColor: Color(0xFFEDE4D9), // Soft Sand
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primaryColor: Color(0xFFA87C5A), // Warm Terracotta
        scaffoldBackgroundColor: Color(0xFF3C2F2F), // Deep Soil Brown
        colorScheme: ColorScheme.dark(
          primary: Color(0xFFA87C5A), // Warm Terracotta
          secondary: Color(0xFF4A704A), // Forest Green
          surface: Color(0xFF3C2F2F), // Deep Soil Brown
        ),
        textTheme: TextTheme(
          bodyLarge: TextStyle(color: Color(0xFFEDE4D9)), // Soft Sand
          bodyMedium: TextStyle(color: Color(0xFFEDE4D9)),
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFFA87C5A), // Warm Terracotta
          foregroundColor: Color(0xFFEDE4D9), // Soft Sand
        ),
        cardColor: Color(0xFF5C4033), // Rich Earth Brown
      ),
      themeMode: ThemeMode.system,
      home: HomeScreen(),
    );
  }
}
