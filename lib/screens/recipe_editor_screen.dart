import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

import '../models/recipe.dart';
import '../services/app_store.dart';
import 'main_navigation.dart';

class RecipeEditorScreen extends StatefulWidget {
  const RecipeEditorScreen({super.key, this.recipe});
  final Recipe? recipe;

  @override
  State<RecipeEditorScreen> createState() => _RecipeEditorScreenState();
}

enum _ImageAction { gallery, camera, remove }

class _RecipeEditorScreenState extends State<RecipeEditorScreen> {
  static const List<String> _defaultCategories = [
    'Prato principal',
    'Pequeno-almoço',
    'Almoço',
    'Jantar',
    'Lanche',
    'Sobremesa',
    'Bebida',
    'Saudável',
    'Outros',
  ];

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _name;
  late final TextEditingController _minutes;
  late final TextEditingController _ingredients;
  late final TextEditingController _instructions;
  final ImagePicker _imagePicker = ImagePicker();
  late String _category;
  String _selectedImagePath = '';
  String _existingImageUrl = '';
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    final recipe = widget.recipe;
    _name = TextEditingController(text: recipe?.name ?? '');
    final savedCategory = recipe?.category ?? _defaultCategories.first;
    _category = _defaultCategories.contains(savedCategory)
        ? savedCategory
        : 'Outros';
    _minutes = TextEditingController(text: recipe?.minutes.toString() ?? '');
    final savedImage = recipe?.imageUrl ?? '';
    if (savedImage.isNotEmpty && !savedImage.startsWith('http')) {
      _selectedImagePath = savedImage;
    }
    if (savedImage.startsWith('http')) _existingImageUrl = savedImage;
    _ingredients = TextEditingController(
      text: recipe?.ingredients.join('\n') ?? '',
    );
    _instructions = TextEditingController(text: recipe?.instructions ?? '');
  }

  @override
  void dispose() {
    _name.dispose();
    _minutes.dispose();
    _ingredients.dispose();
    _instructions.dispose();
    super.dispose();
  }

  String? _required(String? value) =>
      value == null || value.trim().isEmpty ? 'Preencha este campo' : null;

  Future<void> _chooseImage() async {
    final action = await showModalBottomSheet<_ImageAction>(
      context: context,
      builder: (context) => SafeArea(
        child: Wrap(
          children: [
            ListTile(
              leading: const Icon(Icons.photo_library_outlined),
              title: const Text('Escolher da galeria'),
              onTap: () => Navigator.pop(context, _ImageAction.gallery),
            ),
            ListTile(
              leading: const Icon(Icons.camera_alt_outlined),
              title: const Text('Tirar uma foto'),
              onTap: () => Navigator.pop(context, _ImageAction.camera),
            ),
            if (_selectedImagePath.isNotEmpty || _existingImageUrl.isNotEmpty)
              ListTile(
                leading: const Icon(
                  Icons.delete_outline,
                  color: Colors.redAccent,
                ),
                title: const Text('Remover imagem'),
                onTap: () => Navigator.pop(context, _ImageAction.remove),
              ),
          ],
        ),
      ),
    );
    if (!mounted || action == null) return;
    if (action == _ImageAction.remove) {
      setState(() {
        _selectedImagePath = '';
        _existingImageUrl = '';
      });
      return;
    }
    try {
      final picked = await _imagePicker.pickImage(
        source: action == _ImageAction.camera
            ? ImageSource.camera
            : ImageSource.gallery,
        imageQuality: 85,
        maxWidth: 1800,
      );
      if (picked == null) return;
      final appDirectory = await getApplicationSupportDirectory();
      final imageDirectory = Directory('${appDirectory.path}/recipe_images');
      await imageDirectory.create(recursive: true);
      final safeName = picked.name.replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_');
      final destination = File(
        '${imageDirectory.path}/${DateTime.now().microsecondsSinceEpoch}_$safeName',
      );
      await File(picked.path).copy(destination.path);
      if (!mounted) return;
      setState(() {
        _selectedImagePath = destination.path;
        _existingImageUrl = '';
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Não foi possível abrir a imagem. Tente novamente.'),
        ),
      );
    }
  }

  Widget _imagePlaceholder() => Container(
    height: 190,
    color: const Color(0xFFE7E3D8),
    child: const Center(
      child: Icon(Icons.broken_image_outlined, size: 42, color: verde),
    ),
  );

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    final old = widget.recipe;
    final recipe = Recipe(
      id: old?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
      name: _name.text.trim(),
      category: _category,
      minutes: int.tryParse(_minutes.text.trim()) ?? 0,
      imageUrl: _selectedImagePath.isNotEmpty
          ? _selectedImagePath
          : _existingImageUrl,
      ingredients: _ingredients.text
          .split('\n')
          .map((item) => item.trim())
          .where((item) => item.isNotEmpty)
          .toList(),
      instructions: _instructions.text.trim(),
      isFavorite: old?.isFavorite ?? false,
      isMine: true,
    );
    await AppStore.instance.saveRecipe(recipe);
    if (!mounted) return;
    Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.recipe != null;
    return Scaffold(
      backgroundColor: creme,
      appBar: AppBar(title: Text(editing ? 'Editar receita' : 'Nova receita')),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(
                labelText: 'Nome da receita',
                prefixIcon: Icon(Icons.restaurant_menu),
              ),
              validator: _required,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<String>(
                    initialValue: _category,
                    decoration: const InputDecoration(
                      labelText: 'Categoria',
                      prefixIcon: Icon(Icons.category_outlined),
                    ),
                    items: _defaultCategories
                        .map(
                          (category) => DropdownMenuItem(
                            value: category,
                            child: Text(category),
                          ),
                        )
                        .toList(),
                    onChanged: (category) {
                      if (category != null) {
                        setState(() => _category = category);
                      }
                    },
                  ),
                ),
                const SizedBox(width: 12),
                SizedBox(
                  width: 112,
                  child: TextFormField(
                    controller: _minutes,
                    decoration: const InputDecoration(
                      labelText: 'Minutos',
                      suffixText: 'min',
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) => int.tryParse(value ?? '') == null
                        ? 'Número inválido'
                        : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            OutlinedButton.icon(
              onPressed: _chooseImage,
              icon: const Icon(Icons.add_a_photo_outlined),
              label: const Text('Tirar foto ou escolher do telemóvel'),
            ),
            if (_selectedImagePath.isNotEmpty ||
                _existingImageUrl.isNotEmpty) ...[
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(14),
                child: _selectedImagePath.isNotEmpty
                    ? Image.file(
                        File(_selectedImagePath),
                        height: 190,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _imagePlaceholder(),
                      )
                    : Image.network(
                        _existingImageUrl,
                        height: 190,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _imagePlaceholder(),
                      ),
              ),
            ],
            const SizedBox(height: 14),
            TextFormField(
              controller: _ingredients,
              decoration: const InputDecoration(
                labelText: 'Ingredientes',
                hintText: 'Um ingrediente por linha',
                prefixIcon: Icon(Icons.shopping_basket_outlined),
                alignLabelWithHint: true,
              ),
              minLines: 4,
              maxLines: 8,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 14),
            TextFormField(
              controller: _instructions,
              decoration: const InputDecoration(
                labelText: 'Preparação',
                hintText: 'Escreva um passo por linha',
                prefixIcon: Icon(Icons.notes_outlined),
                alignLabelWithHint: true,
              ),
              minLines: 5,
              maxLines: 10,
              textCapitalization: TextCapitalization.sentences,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _saving ? null : _save,
              icon: const Icon(Icons.save_outlined),
              label: Text(_saving ? 'A guardar…' : 'Guardar receita'),
              style: FilledButton.styleFrom(
                backgroundColor: verde,
                padding: const EdgeInsets.symmetric(vertical: 16),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
