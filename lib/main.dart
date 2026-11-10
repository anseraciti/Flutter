import 'package:flutter/material.dart';
import 'screens/main_navigation.dart';

void main() {
  runApp(const ReceitasApp());
}

class ReceitasApp extends StatelessWidget {
  const ReceitasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Sabores de Casa',
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFAF8F2),
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF244B3D),
        ),
      ),
      home: const MainNavigation(),
    );
  }
}