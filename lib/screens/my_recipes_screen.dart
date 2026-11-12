import 'package:flutter/material.dart';

import '../services/app_store.dart';
import '../widgets/recipe_card.dart';
import 'main_navigation.dart';
import 'recipe_editor_screen.dart';
import 'shopping_planner_screen.dart';

class MyRecipesScreen extends StatefulWidget {
  const MyRecipesScreen({super.key});
  @override
  State<MyRecipesScreen> createState() => _MyRecipesScreenState();
}

class _MyRecipesScreenState extends State<MyRecipesScreen> {
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
                    recipe.isMine &&
                    recipe.name.toLowerCase().contains(_query.toLowerCase()),
              )
              .toList();
          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              const _ScreenHeader(
                title: 'Minhas receitas',
                subtitle: 'Organize a sua coleção de receitas',
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: TextField(
                  onChanged: (value) => setState(() => _query = value.trim()),
                  decoration: InputDecoration(
                    hintText: 'Pesquisar nas minhas receitas...',
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
                padding: const EdgeInsets.fromLTRB(20, 14, 20, 0),
                child: OutlinedButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const ShoppingPlannerScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.calendar_month_outlined),
                  label: const Text('Planeador semanal e lista de compras'),
                  style: OutlinedButton.styleFrom(
                    foregroundColor: corPrimaria(context),
                    padding: const EdgeInsets.all(14),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
                child: FilledButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => const RecipeEditorScreen(),
                    ),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Adicionar receita'),
                  style: FilledButton.styleFrom(
                    backgroundColor: verde,
                    padding: const EdgeInsets.all(15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
                child: Text(
                  'A minha coleção (${recipes.length})',
                  style: const TextStyle(
                    fontSize: 21,
                    fontWeight: FontWeight.bold,
                    color: verde,
                  ),
                ),
              ),
              if (recipes.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      const Icon(
                        Icons.menu_book_outlined,
                        size: 42,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _query.isEmpty
                            ? 'Ainda não tem receitas na sua coleção. Adicione a primeira!'
                            : 'Nenhuma receita corresponde à pesquisa.',
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

class _ScreenHeader extends StatelessWidget {
  const _ScreenHeader({required this.title, required this.subtitle});
  final String title;
  final String subtitle;
  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 25,
            fontWeight: FontWeight.bold,
            color: corPrimaria(context),
          ),
        ),
        const SizedBox(height: 5),
        Text(
          subtitle,
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    ),
  );
}
