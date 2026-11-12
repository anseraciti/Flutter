import 'package:flutter/material.dart';

import '../models/kitchen_note.dart';
import '../services/app_store.dart';
import 'main_navigation.dart';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key, this.note});
  final KitchenNote? note;

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _title;
  late final TextEditingController _body;
  bool _saving = false;

  @override
  void initState() {
    super.initState();
    _title = TextEditingController(text: widget.note?.title ?? '');
    _body = TextEditingController(text: widget.note?.body ?? '');
  }

  @override
  void dispose() {
    _title.dispose();
    _body.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);
    await AppStore.instance.saveNote(
      KitchenNote(
        id: widget.note?.id ?? DateTime.now().microsecondsSinceEpoch.toString(),
        title: _title.text.trim(),
        body: _body.text.trim(),
        updatedAt: DateTime.now(),
      ),
    );
    if (mounted) Navigator.pop(context);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: creme,
    appBar: AppBar(
      title: Text(widget.note == null ? 'Nova anotação' : 'Editar anotação'),
    ),
    body: Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          TextFormField(
            controller: _title,
            decoration: const InputDecoration(
              labelText: 'Título',
              prefixIcon: Icon(Icons.title),
            ),
            textCapitalization: TextCapitalization.sentences,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Escreva um título'
                : null,
          ),
          const SizedBox(height: 16),
          TextFormField(
            controller: _body,
            decoration: const InputDecoration(
              labelText: 'Anotação',
              hintText: 'Escreva a sua ideia ou lembrete',
              alignLabelWithHint: true,
            ),
            minLines: 6,
            maxLines: 12,
            textCapitalization: TextCapitalization.sentences,
            validator: (value) => value == null || value.trim().isEmpty
                ? 'Escreva o conteúdo da anotação'
                : null,
          ),
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _saving ? null : _save,
            icon: const Icon(Icons.save_outlined),
            label: Text(_saving ? 'A guardar…' : 'Guardar anotação'),
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
