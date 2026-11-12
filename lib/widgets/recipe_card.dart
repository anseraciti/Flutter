import 'dart:io';

import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../services/app_store.dart';
import '../screens/main_navigation.dart';
import '../screens/recipe_detail_screen.dart';

class RecipeCard extends StatelessWidget {
  const RecipeCard({super.key, required this.recipe});
  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      color:
          Theme.of(context).cardTheme.color ??
          Theme.of(context).colorScheme.surface,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => RecipeDetailScreen(recipeId: recipe.id),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                _RecipeImage(url: recipe.imageUrl, height: 165),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Material(
                    color: Colors.white.withValues(alpha: .92),
                    shape: const CircleBorder(),
                    child: IconButton(
                      icon: Icon(
                        recipe.isFavorite
                            ? Icons.favorite
                            : Icons.favorite_border,
                        color: recipe.isFavorite
                            ? Colors.redAccent
                            : corPrimaria(context),
                      ),
                      tooltip: recipe.isFavorite
                          ? 'Remover dos favoritos'
                          : 'Adicionar aos favoritos',
                      onPressed: () =>
                          AppStore.instance.toggleFavorite(recipe.id),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    recipe.category.toUpperCase(),
                    style: const TextStyle(
                      color: terracota,
                      fontSize: 10,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    recipe.name,
                    style: TextStyle(
                      color: corPrimaria(context),
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 9),
                  Row(
                    children: [
                      const Icon(
                        Icons.access_time,
                        size: 15,
                        color: Colors.grey,
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '${recipe.minutes} min',
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Ver receita',
                        style: TextStyle(
                          color: corPrimaria(context),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Icon(
                        Icons.chevron_right,
                        color: corPrimaria(context),
                        size: 18,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RecipeImage extends StatelessWidget {
  const _RecipeImage({required this.url, required this.height});
  final String url;
  final double height;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return _fallback();
    final isRemote = url.startsWith('http://') || url.startsWith('https://');
    return isRemote
        ? Image.network(
            url,
            width: double.infinity,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _fallback(),
          )
        : Image.file(
            File(url),
            width: double.infinity,
            height: height,
            fit: BoxFit.cover,
            errorBuilder: (_, _, _) => _fallback(),
          );
  }

  Widget _fallback() => Container(
    height: height,
    width: double.infinity,
    color: const Color(0xFFE7E3D8),
    child: const Center(child: Icon(Icons.restaurant, size: 45, color: verde)),
  );
}
