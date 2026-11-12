import 'package:flutter/material.dart';

import '../models/kitchen_note.dart';
import '../services/app_store.dart';
import 'main_navigation.dart';
import 'note_editor_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});
  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  String _query = '';

  Future<void> _delete(KitchenNote note) async {
    await AppStore.instance.deleteNote(note.id);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('“${note.title}” apagada'),
        action: SnackBarAction(
          label: 'Desfazer',
          onPressed: () => AppStore.instance.saveNote(note),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
    backgroundColor: Theme.of(context).scaffoldBackgroundColor,
    body: SafeArea(
      child: AnimatedBuilder(
        animation: AppStore.instance,
        builder: (context, _) {
          final notes =
              AppStore.instance.notes
                  .where(
                    (note) => '${note.title} ${note.body}'
                        .toLowerCase()
                        .contains(_query.toLowerCase()),
                  )
                  .toList()
                ..sort((a, b) => b.updatedAt.compareTo(a.updatedAt));
          return ListView(
            padding: const EdgeInsets.only(bottom: 24),
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Anotações',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: corPrimaria(context),
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'As suas ideias e lembretes de cozinha',
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
                    hintText: 'Pesquisar anotações...',
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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 8),
                child: FilledButton.icon(
                  onPressed: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const NoteEditorScreen()),
                  ),
                  icon: const Icon(Icons.add),
                  label: const Text('Nova anotação'),
                  style: FilledButton.styleFrom(
                    backgroundColor: verde,
                    padding: const EdgeInsets.all(15),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 12),
                child: Text(
                  'As minhas notas (${notes.length})',
                  style: TextStyle(
                    color: corPrimaria(context),
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              if (notes.isEmpty)
                Padding(
                  padding: const EdgeInsets.all(28),
                  child: Column(
                    children: [
                      const Icon(Icons.edit_note, size: 42, color: Colors.grey),
                      const SizedBox(height: 8),
                      Text(
                        _query.isEmpty
                            ? 'Ainda não tem anotações.'
                            : 'Nenhuma anotação corresponde à pesquisa.',
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ...notes.map(
                (note) => Dismissible(
                  key: ValueKey(note.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                    padding: const EdgeInsets.only(right: 20),
                    alignment: Alignment.centerRight,
                    decoration: BoxDecoration(
                      color: Colors.redAccent,
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: const Icon(
                      Icons.delete_outline,
                      color: Colors.white,
                    ),
                  ),
                  onDismissed: (_) => _delete(note),
                  child: Card(
                    margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
                    color:
                        Theme.of(context).cardTheme.color ??
                        Theme.of(context).colorScheme.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.fromLTRB(18, 8, 8, 8),
                      title: Text(
                        note.title,
                        style: TextStyle(
                          color: corPrimaria(context),
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      subtitle: Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          note.body,
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      trailing: PopupMenuButton<String>(
                        onSelected: (value) {
                          if (value == 'edit') {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => NoteEditorScreen(note: note),
                              ),
                            );
                          }
                          if (value == 'delete') {
                            _delete(note);
                          }
                        },
                        itemBuilder: (_) => const [
                          PopupMenuItem(value: 'edit', child: Text('Editar')),
                          PopupMenuItem(value: 'delete', child: Text('Apagar')),
                        ],
                      ),
                      onTap: () => Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => NoteEditorScreen(note: note),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    ),
  );
}
