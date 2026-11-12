import 'package:flutter/material.dart';

import '../models/recipe.dart';
import '../services/app_store.dart';
import 'main_navigation.dart';

class ShoppingPlannerScreen extends StatelessWidget {
  const ShoppingPlannerScreen({super.key});

  @override
  Widget build(BuildContext context) => DefaultTabController(
    length: 2,
    child: Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        title: const Text('Plano da semana'),
        bottom: const TabBar(tabs: [
          Tab(icon: Icon(Icons.calendar_month_outlined), text: 'Planeador'),
          Tab(icon: Icon(Icons.shopping_cart_outlined), text: 'Compras'),
        ]),
      ),
      body: const TabBarView(children: [_WeekPlanTab(), _ShoppingListTab()]),
    ),
  );
}

class _WeekPlanTab extends StatelessWidget {
  const _WeekPlanTab();

  static const _weekdays = [
    'Segunda-feira', 'Terça-feira', 'Quarta-feira', 'Quinta-feira',
    'Sexta-feira', 'Sábado', 'Domingo',
  ];

  List<DateTime> _week() {
    final now = DateTime.now();
    final monday = DateTime(now.year, now.month, now.day - now.weekday + 1);
    return List.generate(7, (index) => monday.add(Duration(days: index)));
  }

  String _key(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String _dateText(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}';

  Future<void> _editDay(BuildContext context, DateTime date, Set<String> initial) async {
    final selected = Set<String>.from(initial);
    final result = await showModalBottomSheet<Set<String>>(
      context: context,
      isScrollControlled: true,
      builder: (context) => StatefulBuilder(builder: (context, setSheetState) {
        final recipes = AppStore.instance.recipes;
        return SafeArea(child: SizedBox(height: MediaQuery.sizeOf(context).height * .78, child: Column(children: [
          Padding(padding: const EdgeInsets.fromLTRB(20, 20, 20, 8), child: Text('Receitas para ${_weekdays[date.weekday - 1]}', style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold))),
          const Padding(padding: EdgeInsets.symmetric(horizontal: 20), child: Text('Pode escolher mais de uma receita para este dia.')),
          Expanded(child: ListView(children: recipes.map((recipe) => CheckboxListTile(value: selected.contains(recipe.id), title: Text(recipe.name), subtitle: Text('${recipe.category} • ${recipe.minutes} min'), secondary: const Icon(Icons.restaurant_menu), onChanged: (checked) => setSheetState(() { if (checked == true) { selected.add(recipe.id); } else { selected.remove(recipe.id); } })).toList())),
          Padding(padding: const EdgeInsets.all(16), child: Row(children: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Cancelar')), const Spacer(), FilledButton(onPressed: () => Navigator.pop(context, selected), style: FilledButton.styleFrom(backgroundColor: verde), child: const Text('Guardar plano'))])),
        ])));
      }),
    );
    if (result != null) await AppStore.instance.setRecipesForDay(_key(date), result);
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: AppStore.instance,
    builder: (context, _) {
      final recipes = {for (final recipe in AppStore.instance.recipes) recipe.id: recipe};
      final days = _week();
      return ListView(padding: const EdgeInsets.all(16), children: [
        const Padding(padding: EdgeInsets.fromLTRB(4, 0, 4, 12), child: Text('Escolha o que vai cozinhar esta semana. A lista de compras será montada a partir destas receitas.', style: TextStyle(color: Colors.grey))),
        ...days.map((date) {
          final key = _key(date);
          final ids = AppStore.instance.weekPlan[key] ?? const <String>[];
          final dayRecipes = ids.map((id) => recipes[id]).whereType<Recipe>().toList();
          return Card(color: Theme.of(context).colorScheme.surface, margin: const EdgeInsets.symmetric(vertical: 6), child: Padding(padding: const EdgeInsets.fromLTRB(16, 12, 8, 12), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [Expanded(child: Text('${_weekdays[date.weekday - 1]} • ${_dateText(date)}', style: TextStyle(color: corPrimaria(context), fontWeight: FontWeight.bold, fontSize: 16))), IconButton(tooltip: 'Escolher receitas', onPressed: () => _editDay(context, date, ids.toSet()), icon: const Icon(Icons.add_circle_outline, color: verde))]),
            if (dayRecipes.isEmpty) const Padding(padding: EdgeInsets.only(bottom: 4), child: Text('Sem receitas planeadas', style: TextStyle(color: Colors.grey)))
            else Wrap(spacing: 8, runSpacing: 4, children: dayRecipes.map((recipe) => InputChip(label: Text(recipe.name), onDeleted: () { final updated = ids.toSet()..remove(recipe.id); AppStore.instance.setRecipesForDay(key, updated); })).toList()),
          ])));
        }),
      ]);
    },
  );
}

class _ShoppingItem {
  const _ShoppingItem({required this.id, required this.name, required this.recipeCount});
  final String id;
  final String name;
  final int recipeCount;
}

class _ShoppingListTab extends StatelessWidget {
  const _ShoppingListTab();

  String _group(String ingredient) {
    final text = ingredient.toLowerCase();
    if (['frango', 'carne', 'peixe', 'marisco', 'camarão', 'porco', 'vaca'].any(text.contains)) return 'Carnes e peixes';
    if (['leite', 'queijo', 'manteiga', 'iogurte', 'natas', 'ovo'].any(text.contains)) return 'Laticínios e ovos';
    if (['cebola', 'tomate', 'batata', 'alface', 'pepino', 'cenoura', 'banana', 'maçã', 'laranja', 'papaia', 'limão', 'coentros', 'alho'].any(text.contains)) return 'Frutas e legumes';
    if (['farinha', 'arroz', 'massa', 'açúcar', 'pão', 'feijão', 'óleo', 'azeite'].any(text.contains)) return 'Mercearia';
    if (['sal', 'pimenta', 'caril', 'canela', 'orégãos', 'manjericão'].any(text.contains)) return 'Temperos';
    return 'Outros';
  }

  Map<String, List<_ShoppingItem>> _items(AppStore store) {
    final recipes = {for (final recipe in store.recipes) recipe.id: recipe};
    final groups = <String, Map<String, _ShoppingItem>>{};
    for (final ids in store.weekPlan.values) {
      for (final id in ids) {
        final recipe = recipes[id];
        if (recipe == null) continue;
        for (final ingredient in recipe.ingredients) {
          final name = ingredient.trim();
          if (name.isEmpty) continue;
          final group = _group(name);
          final key = name.toLowerCase();
          final items = groups.putIfAbsent(group, () => {});
          final previous = items[key];
          items[key] = _ShoppingItem(id: '$group|$key', name: name, recipeCount: (previous?.recipeCount ?? 0) + 1);
        }
      }
    }
    return groups.map((group, items) => MapEntry(group, items.values.toList()..sort((a, b) => a.name.compareTo(b.name))));
  }

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: AppStore.instance,
    builder: (context, _) {
      final grouped = _items(AppStore.instance);
      final hasItems = grouped.values.any((items) => items.isNotEmpty);
      final checked = AppStore.instance.shoppingChecks;
      return ListView(padding: const EdgeInsets.all(16), children: [
        Row(children: [Expanded(child: Text('Ingredientes das receitas planeadas', style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold))), TextButton(onPressed: checked.isEmpty ? null : AppStore.instance.clearShoppingChecks, child: const Text('Limpar marcados'))]),
        if (!hasItems) const Padding(padding: EdgeInsets.symmetric(vertical: 40), child: Column(children: [Icon(Icons.shopping_basket_outlined, size: 52, color: Colors.grey), SizedBox(height: 12), Text('Escolha receitas no planeador para criar a lista de compras.', textAlign: TextAlign.center, style: TextStyle(color: Colors.grey))])),
        ...grouped.entries.map((entry) => Card(color: Theme.of(context).colorScheme.surface, margin: const EdgeInsets.symmetric(vertical: 6), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(padding: const EdgeInsets.fromLTRB(16, 14, 16, 4), child: Text(entry.key, style: TextStyle(color: corPrimaria(context), fontWeight: FontWeight.bold, fontSize: 16))),
          ...entry.value.map((item) => CheckboxListTile(contentPadding: const EdgeInsets.symmetric(horizontal: 16), controlAffinity: ListTileControlAffinity.leading, activeColor: verde, value: checked.contains(item.id), title: Text(item.name, style: TextStyle(decoration: checked.contains(item.id) ? TextDecoration.lineThrough : null)), subtitle: item.recipeCount > 1 ? Text('Usado em ${item.recipeCount} receitas planeadas') : null, onChanged: (_) => AppStore.instance.toggleShoppingCheck(item.id)),
        ]))),
      ]);
    },
  );
}
