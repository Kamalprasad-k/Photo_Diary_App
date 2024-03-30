import 'package:favorite_places_app/screens/place_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final colorScheme = ColorScheme.fromSeed(
  brightness: Brightness.light,
  seedColor: const Color(0xFF87CEEB),
  background: const Color(0xFFE0E0E0),
);

final theme = ThemeData().copyWith(
  scaffoldBackgroundColor: colorScheme.background,
  colorScheme: colorScheme,
  textTheme: TextTheme(
    titleSmall: TextStyle(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 18.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    titleMedium: TextStyle(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 22.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    titleLarge: TextStyle(
      fontFamily: GoogleFonts.openSans().fontFamily,
      fontSize: 24.0,
      fontWeight: FontWeight.bold,
      color: Colors.black,
    ),
    bodyLarge: TextStyle(
      fontFamily: GoogleFonts.lora().fontFamily,
      fontSize: 16.0,
      fontWeight: FontWeight.w500,
      color: Colors.black87,
    ),
    bodyMedium: TextStyle(
      fontFamily: GoogleFonts.lora().fontFamily,
      fontSize: 14.0,
      fontWeight: FontWeight.w400,
      color: Colors.black87,
    ),
    bodySmall: TextStyle(
      fontFamily: GoogleFonts.lora().fontFamily,
      fontSize: 12.0,
      fontWeight: FontWeight.w300,
      color: Colors.black87,
    ),
  ),
);

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MobileAds.instance.initialize();
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: theme,
      home: const PlaceScreen(),
    );
  }
}
