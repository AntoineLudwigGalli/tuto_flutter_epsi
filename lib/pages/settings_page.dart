import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../themes/theme_provider.dart';

/*

Page des Paramètres

- Switch Dark Mode / Light Mode
- Utilisateurs bloqués
- Réglages du compte

*/

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  // Affichage UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text("Paramètres"),
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          // Switch DarkMode
          CupertinoSwitch(
            value:
                Provider.of<ThemeProvider>(context, listen: false).isDarkMode,
            onChanged: (value) =>
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(),
          ),

          // Utilisateurs bloqués

          // Réglages du compte
        ],
      ),
    );
  }
}
