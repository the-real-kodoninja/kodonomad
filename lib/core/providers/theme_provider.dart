import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeProvider extends ChangeNotifier {
  ThemeData _currentTheme;
  final SharedPreferences _prefs;

  ThemeProvider(this._prefs)
      : _currentTheme = _themes[_prefs.getString('theme') ?? 'Minimal Nomad']!;

  static final Map<String, ThemeData> _themes = {
  	'Minimal Nomad': ThemeData(
			primaryColor: const Color(0xFF2E2E2E),
			colorScheme: const ColorScheme.dark(
				primary: Color(0xFF2E2E2E),
				secondary: Color(0xFF4CAF50),
				onPrimary: Colors.white,
				surface: Color(0xFF121212),
				onSurface: Colors.white,
			),
			scaffoldBackgroundColor: const Color(0xFF121212),
			elevatedButtonTheme: ElevatedButtonThemeData(
				style: ButtonStyle(
				  backgroundColor: MaterialStateProperty.all(const Color(0xFF4CAF50)),
				  foregroundColor: MaterialStateProperty.all(Colors.white),
				  shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(12))),
				),
			),
			cardTheme: CardTheme(
				color: const Color(0xFF1E1E1E),
				elevation: 2,
				shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
			),
			textTheme: const TextTheme(
				headlineSmall: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
				bodyLarge: TextStyle(color: Colors.white70),
				bodySmall: TextStyle(color: Colors.white54),
			),
		),
    'Desert Sunset': ThemeData(
      primaryColor: const Color(0xFF8B5A2B),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF8B5A2B),
        secondary: Color(0xFFD9A566),
        onPrimary: Colors.white,
        surface: Color(0xFFFDF6E3),
        onSurface: Colors.black87,
      ),
      scaffoldBackgroundColor: Color(0xFFFDF6E3),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFFF2C94C)),
          foregroundColor: MaterialStateProperty.all(Colors.black87),
        ),
      ),
      cardTheme: CardTheme(color: const Color(0xFFFDF6E3).withOpacity(0.9), elevation: 2),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(color: Color(0xFF8B5A2B)),
        bodyLarge: TextStyle(color: Colors.black87),
      ),
    ),
    'Forest Whisper': ThemeData(
      primaryColor: const Color(0xFF4A7049),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF4A7049),
        secondary: Color(0xFF8BA58F),
        onPrimary: Colors.white,
        surface: Color(0xFFF5F6F0),
        onSurface: Colors.black87,
      ),
      scaffoldBackgroundColor: Color(0xFFF5F6F0),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFFD9C2A7)),
          foregroundColor: MaterialStateProperty.all(Colors.black87),
        ),
      ),
      cardTheme: CardTheme(color: const Color(0xFFF5F6F0).withOpacity(0.9), elevation: 2),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(color: Color(0xFF4A7049)),
        bodyLarge: TextStyle(color: Colors.black87),
      ),
    ),
    'Coastal Drift': ThemeData(
      primaryColor: const Color(0xFF5A7D8C),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF5A7D8C),
        secondary: Color(0xFFA8BDBF),
        onPrimary: Colors.white,
        surface: Color(0xFFF0F4F5),
        onSurface: Colors.black87,
      ),
      scaffoldBackgroundColor: Color(0xFFF0F4F5),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFFE8B5A2)),
          foregroundColor: MaterialStateProperty.all(Colors.black87),
        ),
      ),
      cardTheme: CardTheme(color: const Color(0xFFF0F4F5).withOpacity(0.9), elevation: 2),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(color: Color(0xFF5A7D8C)),
        bodyLarge: TextStyle(color: Colors.black87),
      ),
    ),
    'Autumn Hearth': ThemeData(
      primaryColor: const Color(0xFF9B4F2C),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF9B4F2C),
        secondary: Color(0xFFCDA074),
        onPrimary: Colors.white,
        surface: Color(0xFFFDF2E9),
        onSurface: Colors.black87,
      ),
      scaffoldBackgroundColor: Color(0xFFFDF2E9),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFFE8C39E)),
          foregroundColor: MaterialStateProperty.all(Colors.black87),
        ),
      ),
      cardTheme: CardTheme(color: const Color(0xFFFDF2E9).withOpacity(0.9), elevation: 2),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(color: Color(0xFF9B4F2C)),
        bodyLarge: TextStyle(color: Colors.black87),
      ),
    ),
    'Prairie Dawn': ThemeData(
      primaryColor: const Color(0xFF6B5846),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF6B5846),
        secondary: Color(0xFFBFA68F),
        onPrimary: Colors.white,
        surface: Color(0xFFF8F4EC),
        onSurface: Colors.black87,
      ),
      scaffoldBackgroundColor: Color(0xFFF8F4EC),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFFD9C8A5)),
          foregroundColor: MaterialStateProperty.all(Colors.black87),
        ),
      ),
      cardTheme: CardTheme(color: const Color(0xFFF8F4EC).withOpacity(0.9), elevation: 2),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(color: Color(0xFF6B5846)),
        bodyLarge: TextStyle(color: Colors.black87),
      ),
    ),
    'Studio Ghibli': ThemeData(
      primaryColor: const Color(0xFF4A7C59), // Forest Green
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF4A7C59),
        secondary: Color(0xFF9BB8A5), // Muted Mint
        onPrimary: Colors.white,
        surface: Color(0xFFF5E8C7), // Soft Parchment
        onSurface: Colors.black87,
      ),
      scaffoldBackgroundColor: const Color(0xFFF5E8C7),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(const Color(0xFFDBAB79)), // Warm Ochre
          foregroundColor: MaterialStateProperty.all(Colors.black87),
        ),
      ),
      cardTheme: CardTheme(color: const Color(0xFFF5E8C7).withOpacity(0.9), elevation: 2),
      textTheme: const TextTheme(
        headlineSmall: TextStyle(color: Color(0xFF4A7C59)),
        bodyLarge: TextStyle(color: Colors.black87),
      ),
    ),
    'Elite Nomad': ThemeData(
			primaryColor: const Color(0xFF1A237E),
			colorScheme: const ColorScheme.dark(
				primary: Color(0xFF1A237E),
				secondary: Color(0xFF00BCD4),
				onPrimary: Colors.white,
				surface: Color(0xFF0D1B2A),
				onSurface: Colors.white,
			),
			scaffoldBackgroundColor: const Color(0xFF0D1B2A),
			elevatedButtonTheme: ElevatedButtonThemeData(
				style: ButtonStyle(
				  backgroundColor: MaterialStateProperty.all(const Color(0xFF00BCD4)),
				  foregroundColor: MaterialStateProperty.all(Colors.white),
				),
			),
		),
  };

  ThemeData get currentTheme => _currentTheme;
  List<String> get themeNames => _themes.keys.toList();
  Map<String, ThemeData> get themes => _themes;

  void setTheme(String themeName) {
    if (_themes.containsKey(themeName)) {
      _currentTheme = _themes[themeName]!;
      _prefs.setString('theme', themeName);
      notifyListeners();
    }
  }
}

final themeProvider = FutureProvider<ThemeProvider>((ref) async {
  final prefs = await SharedPreferences.getInstance();
  return ThemeProvider(prefs);
});
