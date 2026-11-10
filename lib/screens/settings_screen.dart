import 'package:flutter/material.dart';
import 'main_navigation.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: creme,
      appBar: AppBar(
        title: const Text(
          'Configurações',
          style: TextStyle(
            color: verde,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: creme,
      ),

      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: verde,
              borderRadius: BorderRadius.circular(18),
            ),
            child: const Row(
              children: [
                Icon(Icons.restaurant_menu,
                    color: Colors.white, size: 35),
                SizedBox(width: 15),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Sabores de Casa',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      'Aplicação de receitas',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 25),

          const Text(
            'PREFERÊNCIAS',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),

          const ListTile(
            leading: Icon(Icons.notifications_none, color: verde),
            title: Text('Notificações'),
            trailing: Icon(Icons.chevron_right),
          ),

          const ListTile(
            leading: Icon(Icons.language, color: verde),
            title: Text('Idioma'),
            subtitle: Text('Português'),
            trailing: Icon(Icons.chevron_right),
          ),

          const ListTile(
            leading: Icon(Icons.palette_outlined, color: verde),
            title: Text('Aparência'),
            subtitle: Text('Tema claro'),
            trailing: Icon(Icons.chevron_right),
          ),

          const Divider(),

          const Text(
            'SOBRE',
            style: TextStyle(
              color: Colors.grey,
              fontWeight: FontWeight.bold,
            ),
          ),

          const ListTile(
            leading: Icon(Icons.info_outline, color: verde),
            title: Text('Sobre a aplicação'),
            subtitle: Text('Versão 1.0.0'),
          ),
        ],
      ),
    );
  }
}