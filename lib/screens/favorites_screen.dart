import 'package:flutter/material.dart';
import 'main_navigation.dart';
import 'settings_screen.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  static const List<Map<String, String>> receitas = [
    {
      'nome': 'Lasanha tradicional',
      'categoria': 'Prato principal',
      'tempo': '60 min',
      'imagem': 'https://images.unsplash.com/photo-1473093295043-cdd812d0e601?w=800',
    },
    {
      'nome': 'Salada de frutas',
      'categoria': 'Sobremesa',
      'tempo': '10 min',
      'imagem': 'https://images.unsplash.com/photo-1490645935967-10de6ba17061?w=800',
    },
    {
      'nome': 'Panquecas',
      'categoria': 'Pequeno-almoço',
      'tempo': '20 min',
      'imagem': 'https://images.unsplash.com/photo-1528207776546-365bb710ee93?w=800',
    },
  ];

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
                          'Favoritos',
                          style: TextStyle(
                            color: verde,
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'As receitas que mais gosta',
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
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar favoritos...',
                  prefixIcon: const Icon(Icons.search, color: verde),
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(15),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
            ),

            const Padding(
              padding: EdgeInsets.all(20),
              child: Text(
                'Receitas guardadas',
                style: TextStyle(
                  color: verde,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            ...receitas.map((receita) {
              return Container(
                margin: const EdgeInsets.fromLTRB(20, 0, 20, 15),
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
                        height: 165,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 165,
                            color: const Color(0xFFE7E3D8),
                            child: const Icon(
                              Icons.restaurant,
                              size: 45,
                              color: verde,
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

                          const SizedBox(height: 8),

                          Text(
                            receita['tempo']!,
                            style: const TextStyle(color: Colors.grey),
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