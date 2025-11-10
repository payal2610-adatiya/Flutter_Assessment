import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'blocs/auth_bloc.dart';
import 'blocs/service_bloc.dart';
import 'screens/splash_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/service_detail_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/bookings_screen.dart';
import 'screens/contact_us_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyCityConnectApp());
}

class MyCityConnectApp extends StatelessWidget {
  const MyCityConnectApp({super.key});

  // 🔹 Load stored login status before building app
  Future<bool> _checkLoginStatus() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('isLoggedIn') ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<bool>(
      future: _checkLoginStatus(),
      builder: (context, snapshot) {
        // Show splash screen while waiting
        if (!snapshot.hasData) {
          return const MaterialApp(
            debugShowCheckedModeBanner: false,
            home: SplashScreen(),
          );
        }

        final isLoggedIn = snapshot.data ?? false;

        return MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => AuthBloc()..add(AuthCheckRequested())),
            BlocProvider(create: (_) => ServiceBloc()..add(LoadServices())),
          ],
          child: MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'MyCityConnect',
            theme: ThemeData(
              primarySwatch: Colors.blue,
              useMaterial3: true,
              visualDensity: VisualDensity.adaptivePlatformDensity,
            ),
            initialRoute: isLoggedIn ? '/home' : '/',
            routes: {
              '/': (context) => const SplashScreen(),
              '/login': (context) => const LoginScreen(),
              '/signup': (context) => const SignupScreen(),
              '/home': (context) => const HomeScreen(),
              '/details': (context) => const ServiceDetailScreen(),
              '/profile': (context) => const ProfileScreen(),
              '/bookings': (context) => const BookingsScreen(),
              '/contact': (context) => const ContactUsScreen(),
            },
          ),
        );
      },
    );
  }
}
