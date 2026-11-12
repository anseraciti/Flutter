import 'package:flutter/material.dart';

import 'screens/main_navigation.dart';
import 'services/app_store.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppStore.instance.load();
  runApp(const ReceitasApp());
}

class ReceitasApp extends StatelessWidget {
  const ReceitasApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: AppStore.instance,
      builder: (context, _) {
        final dark = AppStore.instance.isDark;
        final scheme = ColorScheme.fromSeed(
          seedColor: const Color(0xFF244B3D),
          brightness: dark ? Brightness.dark : Brightness.light,
          surface: dark ? const Color(0xFF1E2923) : Colors.white,
        );
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Sabores de Casa',
          theme: ThemeData(
            useMaterial3: true,
            colorScheme: scheme,
            scaffoldBackgroundColor: dark
                ? const Color(0xFF111814)
                : const Color(0xFFFAF8F2),
            cardColor: dark ? const Color(0xFF1E2923) : Colors.white,
            appBarTheme: AppBarTheme(
              backgroundColor: dark
                  ? const Color(0xFF111814)
                  : const Color(0xFFFAF8F2),
            ),
            inputDecorationTheme: InputDecorationTheme(
              filled: true,
              fillColor: dark ? const Color(0xFF1E2923) : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: BorderSide.none,
              ),
            ),
            navigationBarTheme: NavigationBarThemeData(
              backgroundColor: dark ? const Color(0xFF1E2923) : Colors.white,
            ),
          ),
          home: const MainNavigation(),
        );
      },
    );
  }
}
