import 'package:flutter/material.dart';
import 'main_navigation.dart';
import 'settings_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  static const List<Map<String, String>> receitas = [
    {
      'nome': 'Caril de frango',
      'categoria': 'Prato principal',
      'tempo': '35 min',
      'imagem': 'https://images.unsplash.com/photo-1603894584373-5ac82b2ae398?w=800',
    },
    {
      'nome': 'Salada fresca',
      'categoria': 'Saudável',
      'tempo': '15 min',
      'imagem': 'https://images.unsplash.com/photo-1512621776951-a57141f2eefd?w=800',
    },
    {
      'nome': 'Panquecas caseiras',
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
                          'Sabores de Casa',
                          style: TextStyle(
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                            color: verde,
                          ),
                        ),
                        SizedBox(height: 5),
                        Text(
                          'Inspiração para cozinhar todos os dias',
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

            // BANNER PRINCIPAL
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: verde,
                borderRadius: BorderRadius.circular(22),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'COZINHAR COM AMOR',
                    style: TextStyle(
                      color: Color(0xFFE8C7A8),
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 1.5,
                    ),
                  ),
                  SizedBox(height: 14),
                  Text(
                    'O que vamos\npreparar hoje?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 27,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Descubra receitas simples e deliciosas.',
                    style: TextStyle(
                      color: Colors.white70,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            // CAMPO DE PESQUISA
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 10),
              child: TextField(
                decoration: InputDecoration(
                  hintText: 'Pesquisar receitas...',
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

            // TÍTULO DA SECÇÃO
            const Padding(
              padding: EdgeInsets.fromLTRB(20, 20, 20, 12),
              child: Text(
                'Sugestões para si',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                  color: verde,
                ),
              ),
            ),

            // CARTÕES DE RECEITAS
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