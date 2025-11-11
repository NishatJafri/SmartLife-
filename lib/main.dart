import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'splash_screen.dart';

// ✅ Add these imports
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialize Firebase using options from firebase_options.dart
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
    debugPrint("Firebase has been successfully initialized!");
  } catch (e) {
    debugPrint("Firebase initialization failed: $e");
  }

  final prefs = await SharedPreferences.getInstance();
  final isDarkMode = prefs.getBool('isDarkMode') ?? false;
  final isLoggedIn = prefs.getBool('isLoggedIn') ?? false;

  runApp(MyApp(
    isDarkMode: isDarkMode,
    isLoggedIn: isLoggedIn,
  ));
}

class MyApp extends StatefulWidget {
  final bool isDarkMode;
  final bool isLoggedIn;

  const MyApp({super.key, required this.isDarkMode, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late bool _isDarkMode;
  late bool _isLoggedIn;

  @override
  void initState() {
    super.initState();
    _isDarkMode = widget.isDarkMode;
    _isLoggedIn = widget.isLoggedIn;

    // ✅ Optional console message
    debugPrint("🌐 App started with Firebase initialized successfully!");
  }

  void toggleTheme(bool value) async {
    setState(() {
      _isDarkMode = value;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isDarkMode', value);
  }

  void updateLoginState(bool value) async {
    setState(() {
      _isLoggedIn = value;
    });
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool('isLoggedIn', value);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'SmartLife+',
      themeMode: _isDarkMode ? ThemeMode.dark : ThemeMode.light,
      theme: ThemeData(
        brightness: Brightness.light,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.grey.shade100,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurple,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.deepPurple,
        scaffoldBackgroundColor: Colors.black,
        floatingActionButtonTheme: const FloatingActionButtonThemeData(
          backgroundColor: Colors.deepPurpleAccent,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurpleAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
      ),
      home: SplashScreen(
        isDarkMode: _isDarkMode,
        toggleTheme: toggleTheme,
        isLoggedIn: _isLoggedIn,
        updateLoginState: updateLoginState,
      ),
    );
  }
}
