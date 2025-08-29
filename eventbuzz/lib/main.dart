import 'package:flutter/material.dart';
import 'screens/splash_screen.dart';
import 'theme.dart';

void main() {
  runApp(EventBuzzApp());
}

class EventBuzzApp extends StatefulWidget {
  @override
  State<EventBuzzApp> createState() => _EventBuzzAppState();
}

class _EventBuzzAppState extends State<EventBuzzApp> {
  ThemeMode themeMode = ThemeMode.light;

  void toggleTheme() {
    setState(() {
      themeMode = themeMode == ThemeMode.light ? ThemeMode.dark : ThemeMode.light;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "EventBuzz",
      theme: lightTheme,
      darkTheme: darkTheme,
      themeMode: themeMode,
      debugShowCheckedModeBanner: false,
      home: SplashScreen(onThemeToggle: toggleTheme),
    );
  }
}
