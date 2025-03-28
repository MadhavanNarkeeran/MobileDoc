import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'views/navigation/app_navigation.dart';

class MobileDocApp extends StatelessWidget {
  const MobileDocApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mobile Doc',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      home: const AppNavigation(),
    );
  }
}
