class Recipe {
  const Recipe({
    required this.id,
    required this.name,
    required this.category,
    required this.minutes,
    this.imageUrl = '',
    this.ingredients = const [],
    this.instructions = '',
    this.isFavorite = false,
    this.isMine = false,
  });

  final String id;
  final String name;
  final String category;
  final int minutes;
  final String imageUrl;
  final List<String> ingredients;
  final String instructions;
  final bool isFavorite;
  final bool isMine;

  List<String> get preparationSteps {
    final lines = instructions
        .split(RegExp(r'\r?\n'))
        .map((step) => step.trim())
        .where((step) => step.isNotEmpty)
        .toList();
    if (lines.length > 1) return lines;
    if (lines.isEmpty) return const ['Adicione os passos desta receita.'];
    return lines.first
        .split(RegExp(r'(?<=[.!?])\s+'))
        .map((step) => step.trim())
        .where((step) => step.isNotEmpty)
        .toList();
  }

  Recipe copyWith({
    String? name,
    String? category,
    int? minutes,
    String? imageUrl,
    List<String>? ingredients,
    String? instructions,
    bool? isFavorite,
    bool? isMine,
  }) => Recipe(
    id: id,
    name: name ?? this.name,
    category: category ?? this.category,
    minutes: minutes ?? this.minutes,
    imageUrl: imageUrl ?? this.imageUrl,
    ingredients: ingredients ?? this.ingredients,
    instructions: instructions ?? this.instructions,
    isFavorite: isFavorite ?? this.isFavorite,
    isMine: isMine ?? this.isMine,
  );

  Map<String, Object?> toJson() => {
    'id': id,
    'name': name,
    'category': category,
    'minutes': minutes,
    'imageUrl': imageUrl,
    'ingredients': ingredients,
    'instructions': instructions,
    'isFavorite': isFavorite,
    'isMine': isMine,
  };

  factory Recipe.fromJson(Map<String, dynamic> json) => Recipe(
    id: json['id'] as String,
    name: json['name'] as String? ?? '',
    category: json['category'] as String? ?? 'Outros',
    minutes: json['minutes'] as int? ?? 0,
    imageUrl: json['imageUrl'] as String? ?? '',
    ingredients: (json['ingredients'] as List<dynamic>? ?? []).cast<String>(),
    instructions: json['instructions'] as String? ?? '',
    isFavorite: json['isFavorite'] as bool? ?? false,
    isMine: json['isMine'] as bool? ?? false,
  );
}
