import 'package:flutter/material.dart';

import '../services/app_store.dart';
import 'main_navigation.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) => AnimatedBuilder(
    animation: AppStore.instance,
    builder: (context, _) {
      final dark = AppStore.instance.isDark;
      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        appBar: AppBar(
          title: Text(
            'Configurações',
            style: TextStyle(
              color: corPrimaria(context),
              fontWeight: FontWeight.bold,
            ),
          ),
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
                  Icon(Icons.restaurant_menu, color: Colors.white, size: 35),
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
                        'A sua coleção de receitas',
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
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            SwitchListTile(
              contentPadding: EdgeInsets.zero,
              secondary: Icon(
                Icons.palette_outlined,
                color: corPrimaria(context),
              ),
              title: const Text('Tema escuro'),
              subtitle: Text(dark ? 'Ativado' : 'Desativado'),
              value: dark,
              activeTrackColor: verde,
              onChanged: AppStore.instance.setDark,
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.language, color: corPrimaria(context)),
              title: Text('Idioma'),
              subtitle: Text('Português'),
            ),
            const Divider(),
            const Text(
              'SOBRE',
              style: TextStyle(color: Colors.grey, fontWeight: FontWeight.bold),
            ),
            ListTile(
              contentPadding: EdgeInsets.zero,
              leading: Icon(Icons.info_outline, color: corPrimaria(context)),
              title: const Text('Sobre a aplicação'),
              subtitle: const Text('Versão 1.0.0'),
              onTap: () => showAboutDialog(
                context: context,
                applicationName: 'Sabores de Casa',
                applicationVersion: '1.0.0',
                applicationLegalese:
                    'Receitas e anotações guardadas neste dispositivo.',
              ),
            ),
          ],
        ),
      );
    },
  );
}
