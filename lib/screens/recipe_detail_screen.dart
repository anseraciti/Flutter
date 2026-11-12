import 'dart:io';

import 'package:flutter/material.dart';

import '../services/app_store.dart';
import 'main_navigation.dart';
import 'cooking_mode_screen.dart';
import 'recipe_editor_screen.dart';

class RecipeDetailScreen extends StatefulWidget {
  const RecipeDetailScreen({super.key, required this.recipeId});
  final String recipeId;

  @override
  State<RecipeDetailScreen> createState() => _RecipeDetailScreenState();
}

class _RecipeDetailScreenState extends State<RecipeDetailScreen> {
  final Set<String> _checkedIngredients = {};

  Future<void> _delete(BuildContext context) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Apagar receita?'),
        content: const Text('Esta ação remove a receita da sua coleção.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Apagar'),
          ),
        ],
      ),
    );
    if (confirm != true || !context.mounted) return;
    await AppStore.instance.deleteRecipe(widget.recipeId);
    if (context.mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: AppStore.instance,
    builder: (context, _) {
      final recipes = AppStore.instance.recipes;
      final index = recipes.indexWhere(
        (recipe) => recipe.id == widget.recipeId,
      );
      if (index < 0) {
        return const Scaffold(
          body: Center(child: Text('Receita não encontrada.')),
        );
      }
      final recipe = recipes[index];
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            recipe.name,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          actions: [
            IconButton(
              tooltip: recipe.isFavorite
                  ? 'Remover dos favoritos'
                  : 'Adicionar aos favoritos',
              onPressed: () => AppStore.instance.toggleFavorite(recipe.id),
              icon: Icon(
                recipe.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: recipe.isFavorite ? Colors.redAccent : null,
              ),
            ),
            if (recipe.isMine)
              PopupMenuButton<String>(
                onSelected: (action) {
                  if (action == 'edit') {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => RecipeEditorScreen(recipe: recipe),
                      ),
                    );
                  }
                  if (action == 'delete') {
                    _delete(context);
                  }
                },
                itemBuilder: (_) => const [
                  PopupMenuItem(value: 'edit', child: Text('Editar')),
                  PopupMenuItem(value: 'delete', child: Text('Apagar')),
                ],
              ),
          ],
        ),
        body: ListView(
          children: [
            if (recipe.imageUrl.isNotEmpty)
              (recipe.imageUrl.startsWith('http://') ||
                      recipe.imageUrl.startsWith('https://')
                  ? Image.network(
                      recipe.imageUrl,
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _imageFallback(),
                    )
                  : Image.file(
                      File(recipe.imageUrl),
                      height: 250,
                      width: double.infinity,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) => _imageFallback(),
                    )),
            if (recipe.imageUrl.isEmpty) _imageFallback(),
            Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.category.toUpperCase(),
                    style: const TextStyle(
                      color: terracota,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: corPrimaria(context),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      const Icon(Icons.schedule, color: verde),
                      const SizedBox(width: 8),
                      Text('Preparação: ${recipe.minutes} minutos'),
                    ],
                  ),
                  const SizedBox(height: 14),
                  SizedBox(
                    width: double.infinity,
                    child: FilledButton.icon(
                      onPressed: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) =>
                              CookingModeScreen(recipeId: recipe.id),
                        ),
                      ),
                      icon: const Icon(Icons.soup_kitchen_outlined),
                      label: const Text('Começar a cozinhar'),
                      style: FilledButton.styleFrom(backgroundColor: verde),
                    ),
                  ),
                  const SizedBox(height: 24),
                  Text(
                    'Ingredientes',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: corPrimaria(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  if (recipe.ingredients.isEmpty)
                    const Text('Ainda não foram adicionados ingredientes.'),
                  ...recipe.ingredients.map(
                    (item) => CheckboxListTile(
                      contentPadding: EdgeInsets.zero,
                      controlAffinity: ListTileControlAffinity.leading,
                      activeColor: corPrimaria(context),
                      title: Text(item),
                      value: _checkedIngredients.contains(item),
                      onChanged: (value) => setState(() {
                        if (value == true) {
                          _checkedIngredients.add(item);
                        } else {
                          _checkedIngredients.remove(item);
                        }
                      }),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Preparação',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      color: corPrimaria(context),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    recipe.instructions.isEmpty
                        ? 'Ainda não foram adicionados passos de preparação.'
                        : recipe.instructions,
                    style: Theme.of(context).textTheme.bodyLarge
                        ?.copyWith(height: 1.55),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    },
  );

  Widget _imageFallback() => Container(
    height: 220,
    color: const Color(0xFFE7E3D8),
    child: const Center(child: Icon(Icons.restaurant, size: 60, color: verde)),
  );
}
