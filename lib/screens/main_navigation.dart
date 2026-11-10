import 'package:flutter/material.dart';

import 'home_screen.dart';
import 'my_recipes_screen.dart';
import 'notes_screen.dart';
import 'favorites_screen.dart';

const Color verde = Color(0xFF244B3D);
const Color creme = Color(0xFFFAF8F2);
const Color terracota = Color(0xFFC8795B);

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int paginaSelecionada = 0;

  final List<Widget> paginas = const [
    HomeScreen(),
    MyRecipesScreen(),
    NotesScreen(),
    FavoritesScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: IndexedStack(
          index: paginaSelecionada,
          children: paginas,
        ),
      ),

      bottomNavigationBar: NavigationBar(
        selectedIndex: paginaSelecionada,

        onDestinationSelected: (index) {
          setState(() {
            paginaSelecionada = index;
          });
        },

        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFFE5EDE7),

        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Início',
          ),

          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book),
            label: 'Minhas receitas',
          ),

          NavigationDestination(
            icon: Icon(Icons.edit_note_outlined),
            selectedIcon: Icon(Icons.edit_note),
            label: 'Anotações',
          ),

          NavigationDestination(
            icon: Icon(Icons.favorite_border),
            selectedIcon: Icon(Icons.favorite),
            label: 'Favoritos',
          ),
        ],
      ),
    );
  }
}