import 'package:flutter/material.dart';
import 'main_navigation.dart';
import 'settings_screen.dart';

class NotesScreen extends StatelessWidget {
  const NotesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creme,

      body: SafeArea(
        child: ListView(
          children: [

            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Anotações',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: verde,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'As suas ideias e lembretes de cozinha',
                          style: TextStyle(color: Colors.grey),
                        ),
                      ],
                    ),
                  ),

                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const SettingsScreen(),
                        ),
                      );
                    },
                    icon: const Icon(Icons.settings_outlined),
                    color: verde,
                  ),
                ],
              ),
            ),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.add),
                label: const Text('Nova anotação'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: verde,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(15),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'As minhas notas',
                style: TextStyle(
                  color: verde,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            nota('Molho de tomate',
                'Adicionar manjericão no final da preparação.'),

            nota('Bolo de cenoura',
                'Experimentar uma nova cobertura.'),

            nota('Lista de compras',
                'Farinha, ovos, tomate e azeite.'),
          ],
        ),
      ),
    );
  }

  Widget nota(String titulo, String descricao) {
    return Container(
      margin: const EdgeInsets.fromLTRB(20, 0, 20, 14),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(17),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            titulo,
            style: const TextStyle(
              color: verde,
              fontSize: 17,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 9),
          Text(
            descricao,
            style: const TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
