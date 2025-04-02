import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'core/theme/app_theme.dart';
import 'views/auth/welcome_page.dart';
import 'views/navigation/app_navigation.dart';

class MobileDocApp extends StatelessWidget {
  const MobileDocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Doc',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: StreamBuilder<User?>(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }
          // go to main navigation if user is log in
          if (snapshot.hasData) {
            return const AppNavigation();
          }
          // show the login page.
          return const WelcomePage();
        },
      ),
    );
  }
}
