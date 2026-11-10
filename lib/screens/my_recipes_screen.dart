import 'package:flutter/material.dart';
import 'main_navigation.dart';
import 'settings_screen.dart';

class MyRecipesScreen extends StatelessWidget {
  const MyRecipesScreen({super.key});

  static const List<Map<String, String>> receitas = [
    {
      'nome': 'Arroz de marisco',
      'categoria': 'Almoço',
      'tempo': '50 min',
      'imagem': 'https://images.unsplash.com/photo-1559847844-5315695dadae?w=800',
    },
    {
      'nome': 'Bolo de laranja',
      'categoria': 'Sobremesa',
      'tempo': '45 min',
      'imagem': 'https://images.unsplash.com/photo-1588195538326-c5b1e9f80a1b?w=800',
    },
    {
      'nome': 'Frango assado',
      'categoria': 'Jantar',
      'tempo': '60 min',
      'imagem': 'https://images.unsplash.com/photo-1532550907401-a500c9a57435?w=800',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creme,

      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.only(bottom: 20),
          children: [

            // CABEÇALHO
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 18),
              child: Row(
                children: [
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Minhas receitas',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: verde,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Organize as suas receitas favoritas',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey,
                          ),
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

            // PESQUISA
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar nas minhas receitas...',
                  prefixIcon: const Icon(
                    Icons.search,
                    color: verde,
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            // BOTÃO ADICIONAR
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 18, 20, 10),
              child: ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        'A funcionalidade de adicionar receitas será implementada posteriormente.',
                      ),
                    ),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Adicionar receita'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: verde,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.all(15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),

            // TÍTULO
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                'A minha coleção',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: verde,
                ),
              ),
            ),

            // LISTA DE RECEITAS
            ...receitas.map((receita) {
              return Container(
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(
                        top: Radius.circular(18),
                      ),
                      child: Image.network(
                        receita['imagem']!,
                        width: double.infinity,
                        height: 165,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 165,
                            color: const Color(0xFFE7E3D8),
                            child: const Center(
                              child: Icon(
                                Icons.restaurant,
                                size: 45,
                                color: verde,
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(14),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            receita['categoria']!.toUpperCase(),
                            style: const TextStyle(
                              color: terracota,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 6),

                          Text(
                            receita['nome']!,
                            style: const TextStyle(
                              color: verde,
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
                                receita['tempo']!,
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}