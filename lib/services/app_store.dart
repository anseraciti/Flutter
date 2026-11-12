import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/kitchen_note.dart';
import '../models/recipe.dart';

class AppStore extends ChangeNotifier {
  AppStore._();
  static final AppStore instance = AppStore._();

  static const _recipesKey = 'recipes_v1';
  static const _notesKey = 'notes_v1';
  static const _darkKey = 'dark_mode_v1';
  static const _weekPlanKey = 'week_plan_v1';
  static const _shoppingChecksKey = 'shopping_checks_v1';

  List<Recipe> _recipes = [];
  List<KitchenNote> _notes = [];
  bool _isDark = false;
  Map<String, List<String>> _weekPlan = {};
  Set<String> _shoppingChecks = {};

  List<Recipe> get recipes => List.unmodifiable(_recipes);
  List<KitchenNote> get notes => List.unmodifiable(_notes);
  bool get isDark => _isDark;
  Map<String, List<String>> get weekPlan => Map.unmodifiable(
    _weekPlan.map(
      (day, recipeIds) => MapEntry(day, List.unmodifiable(recipeIds)),
    ),
  );
  Set<String> get shoppingChecks => Set.unmodifiable(_shoppingChecks);

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _isDark = prefs.getBool(_darkKey) ?? false;
    try {
      final planData = prefs.getString(_weekPlanKey);
      final decoded = planData == null
          ? <String, dynamic>{}
          : jsonDecode(planData) as Map<String, dynamic>;
      _weekPlan = decoded.map(
        (day, ids) => MapEntry(day, (ids as List<dynamic>).cast<String>()),
      );
      _shoppingChecks = (jsonDecode(
        prefs.getString(_shoppingChecksKey) ?? '[]',
      ) as List<dynamic>).cast<String>().toSet();
    } catch (_) {
      _weekPlan = {};
      _shoppingChecks = {};
    }
    final recipeData = prefs.getString(_recipesKey);
    if (recipeData == null) {
      _recipes = _initialRecipes();
      _notes = _initialNotes();
      await _saveRecipes();
      await _saveNotes();
    } else {
      try {
        _recipes = (jsonDecode(recipeData) as List<dynamic>)
            .map((item) => Recipe.fromJson(item as Map<String, dynamic>))
            .toList();
      } catch (_) {
        _recipes = _initialRecipes();
      }
      final noteData = prefs.getString(_notesKey);
      try {
        _notes = noteData == null
            ? []
            : (jsonDecode(noteData) as List<dynamic>)
                  .map(
                    (item) =>
                        KitchenNote.fromJson(item as Map<String, dynamic>),
                  )
                  .toList();
      } catch (_) {
        _notes = [];
      }
    }
    notifyListeners();
  }

  List<Recipe> _initialRecipes() => const [
    Recipe(
      id: 'chicken-curry',
      name: 'Caril de frango',
      category: 'Prato principal',
      minutes: 35,
      imageUrl:
          'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=800',
      ingredients: [
        '500 g de frango',
        '1 cebola',
        '2 tomates',
        '200 ml de leite de coco',
        'Caril, sal e azeite',
      ],
      instructions: 'Refogue a cebola no azeite. Junte o frango e o caril. Acrescente o tomate e o leite de coco e cozinhe até o frango ficar macio.',
    ),
    Recipe(
      id: 'fresh-salad',
      name: 'Salada fresca',
      category: 'Saudável',
      minutes: 15,
      imageUrl:
          'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
      ingredients: ['Alface', '2 tomates', '1 pepino', 'Azeite e limão'],
      instructions: 'Lave e corte os legumes. Tempere com azeite, limão e sal antes de servir.',
    ),
    Recipe(
      id: 'pancakes',
      name: 'Panquecas caseiras',
      category: 'Pequeno-almoço',
      minutes: 20,
      imageUrl:
          'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=800',
      isFavorite: true,
      ingredients: [
        '1 chávena de farinha',
        '1 ovo',
        '1 chávena de leite',
        '1 colher de açúcar',
      ],
      instructions: 'Misture os ingredientes até obter uma massa lisa. Cozinhe porções numa frigideira untada, virando quando surgirem bolhas.',
    ),
    Recipe(
      id: 'seafood-rice',
      name: 'Arroz de marisco',
      category: 'Almoço',
      minutes: 50,
      imageUrl:
          'https://images.unsplash.com/photo-1559847844-5315695dadae?w=800',
      isMine: true,
      ingredients: [
        '2 chávenas de arroz',
        '500 g de marisco',
        '1 cebola',
        'Tomate e coentros',
      ],
      instructions: 'Refogue a cebola e o tomate. Junte o marisco e água quente. Acrescente o arroz e cozinhe até ficar macio.',
    ),
    Recipe(
      id: 'orange-cake',
      name: 'Bolo de laranja',
      category: 'Sobremesa',
      minutes: 45,
      imageUrl:
          'https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b?w=800',
      isMine: true,
      ingredients: [
        '2 chávenas de farinha',
        '1 chávena de açúcar',
        '3 ovos',
        'Sumo de 2 laranjas',
      ],
      instructions: 'Bata os ovos com o açúcar, junte o sumo e a farinha. Leve ao forno a 180 °C por cerca de 35 minutos.',
    ),
    Recipe(
      id: 'roast-chicken',
      name: 'Frango assado',
      category: 'Jantar',
      minutes: 60,
      imageUrl:
          'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=800',
      isMine: true,
      ingredients: ['1 frango', 'Alho', 'Limão', 'Sal e pimenta'],
      instructions: 'Tempere o frango e deixe repousar. Asse a 190 °C até dourar, regando com o próprio molho.',
    ),
    Recipe(
      id: 'lasagna',
      name: 'Lasanha tradicional',
      category: 'Prato principal',
      minutes: 60,
      imageUrl:
          'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=800',
      isFavorite: true,
      ingredients: [
        'Placas de lasanha',
        'Carne moída',
        'Molho de tomate',
        'Queijo e molho branco',
      ],
      instructions: 'Faça camadas de massa, carne com molho e molho branco. Cubra com queijo e leve ao forno até gratinar.',
    ),
    Recipe(
      id: 'fruit-salad',
      name: 'Salada de frutas',
      category: 'Sobremesa',
      minutes: 10,
      imageUrl:
          'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800',
      isFavorite: true,
      ingredients: ['Banana', 'Maçã', 'Laranja', 'Papaia'],
      instructions:
          'Lave, descasque e corte as frutas. Misture e sirva fresca.',
    ),
  ];

  List<KitchenNote> _initialNotes() => [
    KitchenNote(
      id: 'note-tomato',
      title: 'Molho de tomate',
      body: 'Adicionar manjericão no final da preparação.',
      updatedAt: DateTime.now(),
    ),
    KitchenNote(
      id: 'note-cake',
      title: 'Bolo de cenoura',
      body: 'Experimentar uma nova cobertura.',
      updatedAt: DateTime.now(),
    ),
    KitchenNote(
      id: 'note-shopping',
      title: 'Lista de compras',
      body: 'Farinha, ovos, tomate e azeite.',
      updatedAt: DateTime.now(),
    ),
  ];

  Future<void> _saveRecipes() async =>
      (await SharedPreferences.getInstance()).setString(
        _recipesKey,
        jsonEncode(_recipes.map((recipe) => recipe.toJson()).toList()),
      );

  Future<void> _saveNotes() async =>
      (await SharedPreferences.getInstance()).setString(
        _notesKey,
        jsonEncode(_notes.map((note) => note.toJson()).toList()),
      );

  Future<void> saveRecipe(Recipe recipe) async {
    final index = _recipes.indexWhere((item) => item.id == recipe.id);
    if (index < 0) {
      _recipes = [..._recipes, recipe];
    } else {
      _recipes[index] = recipe;
    }
    await _saveRecipes();
    notifyListeners();
  }

  Future<void> deleteRecipe(String id) async {
    _recipes = _recipes.where((recipe) => recipe.id != id).toList();
    await _saveRecipes();
    notifyListeners();
  }

  Future<void> toggleFavorite(String id) async {
    final index = _recipes.indexWhere((recipe) => recipe.id == id);
    if (index < 0) return;
    _recipes[index] = _recipes[index].copyWith(
      isFavorite: !_recipes[index].isFavorite,
    );
    await _saveRecipes();
    notifyListeners();
  }

  Future<void> saveNote(KitchenNote note) async {
    final index = _notes.indexWhere((item) => item.id == note.id);
    if (index < 0) {
      _notes = [note, ..._notes];
    } else {
      _notes[index] = note;
    }
    await _saveNotes();
    notifyListeners();
  }

  Future<void> deleteNote(String id) async {
    _notes = _notes.where((note) => note.id != id).toList();
    await _saveNotes();
    notifyListeners();
  }

  Future<void> setDark(bool value) async {
    _isDark = value;
    await (await SharedPreferences.getInstance()).setBool(_darkKey, value);
    notifyListeners();
  }

  Future<void> setRecipesForDay(String day, Set<String> recipeIds) async {
    _weekPlan = {..._weekPlan};
    if (recipeIds.isEmpty) {
      _weekPlan.remove(day);
    } else {
      _weekPlan[day] = recipeIds.toList();
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weekPlanKey, jsonEncode(_weekPlan));
    notifyListeners();
  }

  Future<void> toggleShoppingCheck(String itemId) async {
    if (_shoppingChecks.contains(itemId)) {
      _shoppingChecks.remove(itemId);
    } else {
      _shoppingChecks.add(itemId);
    }
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _shoppingChecksKey,
      jsonEncode(_shoppingChecks.toList()),
    );
    notifyListeners();
  }

  Future<void> clearShoppingChecks() async {
    _shoppingChecks.clear();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_shoppingChecksKey, '[]');
    notifyListeners();
  }
}
