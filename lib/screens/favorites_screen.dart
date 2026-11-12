import 'package:flutter/material.dart';

import '../services/app_store.dart';
import '../widgets/recipe_card.dart';
import 'main_navigation.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});
  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
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
                    recipe.isFavorite &&
                    recipe.name.toLowerCase().contains(_query.toLowerCase()),
              )
              .toList();
          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Favoritos',
                      style: TextStyle(
                        color: corPrimaria(context),
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'As receitas que mais gosta',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  onChanged: (value) => setState(() => _query = value.trim()),
                  decoration: InputDecoration(
                    hintText: 'Pesquisar favoritos...',
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
                  'Receitas guardadas (${recipes.length})',
                  style: TextStyle(
                    color: corPrimaria(context),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (recipes.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.favorite_border,
                        size: 42,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _query.isEmpty
                            ? 'Ainda não guardou receitas. Toque no coração de uma receita para a adicionar aqui.'
                            : 'Nenhum favorito corresponde à pesquisa.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ...recipes.map((recipe) => RecipeCard(recipe: recipe)),
            ],
          );
        },
      ),
    ),
  );
}
