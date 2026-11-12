import 'package:flutter/material.dart';

import '../services/app_store.dart';
import '../widgets/recipe_card.dart';
import 'main_navigation.dart';
import 'settings_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    body: SafeArea(
      child: AnimatedBuilder(
        animation: AppStore.instance,
        builder: (context, _) {
          final recipes = AppStore.instance.recipes
              .where(
                (recipe) =>
                    !recipe.isMine &&
                    recipe.name.toLowerCase().contains(_query.toLowerCase()),
              )
              .toList();
          return ListView(
            padding: const EdgeInsets.only(bottom: 20),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Sabores de Casa',
                            style: TextStyle(
                              fontSize: 25,
                              fontWeight: FontWeight.bold,
                              color: corPrimaria(context),
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'Inspiração para cozinhar todos os dias',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      tooltip: 'Configurações',
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      ),
                      icon: const Icon(Icons.settings_outlined, color: verde),
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 20),
                padding: const EdgeInsets.all(22),
                decoration: BoxDecoration(
                  color: verde,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'COZINHAR COM AMOR',
                      style: TextStyle(
                        color: Color(0xFFE8C7A8),
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 1.5,
                      ),
                    ),
                    SizedBox(height: 14),
                    Text(
                      'O que vamos\npreparar hoje?',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 27,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Descubra receitas simples e deliciosas.',
                      style: TextStyle(color: Colors.white70, fontSize: 13),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
                child: TextField(
                  onChanged: (value) => setState(() => _query = value.trim()),
                  decoration: InputDecoration(
                    hintText: 'Pesquisar receitas...',
                    prefixIcon: const Icon(Icons.search, color: verde),
                    filled: true,
                    fillColor: Theme.of(context).cardColor,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Text(
                  _query.isEmpty
                      ? 'Sugestões para si'
                      : 'Resultados (${recipes.length})',
                  style: TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: corPrimaria(context),
                  ),
                ),
              ),
              if (recipes.isEmpty)
                const _EmptyResults(
                  message: 'Não encontrámos receitas com esse nome.',
                ),
              ...recipes.map((recipe) => RecipeCard(recipe: recipe)),
            ],
          );
        },
      ),
    ),
  );
}

class _EmptyResults extends StatelessWidget {
  const _EmptyResults({required this.message});
  final String message;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.all(28),
    child: Column(
      children: [
        const Icon(Icons.search_off, size: 40, color: Colors.grey),
        const SizedBox(height: 8),
        Text(
          message,
          textAlign: TextAlign.center,
          style: const TextStyle(color: Colors.grey),
        ),
      ],
    ),
  );
}
