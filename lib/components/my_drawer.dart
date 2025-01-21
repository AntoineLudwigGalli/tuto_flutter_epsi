import 'package:flutter/material.dart';

import 'my_drawer_tile.dart';

/*

MENU DRAWER

Un menu accessible par un bouton en déployant
une navigation latérale

----------------------------------------------------

Les options du menu sont :

- Accueil
- Profil
- Rechercher
- Paramètres
- Déconnexion

*/

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  // Affichage UI
  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Theme.of(context).colorScheme.surface,

      // Icone (logo)
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Icon(
                  Icons.person,
                  size: 72,
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              Divider(
                indent: 25,
                endIndent: 25,
                color: Theme.of(context).colorScheme.secondary,
              ),
              const SizedBox(
                height: 10,
              ),

              // Tiles
              // Accueil
              MyDrawerTile(
                title: "Accueil",
                icon: Icons.home,
                onTap: () {
                  Navigator.pop(context);
                },
              ),

              // Profil
              MyDrawerTile(
                title: "Profil",
                icon: Icons.person,
                onTap: () {},
              ),

              // Rechercher
              MyDrawerTile(
                title: "Rechercher",
                icon: Icons.search,
                onTap: () {},
              ),

              // Paramètres
              MyDrawerTile(
                title: "Paramètres",
                icon: Icons.settings,
                onTap: () {},
              ),

              // Déconnexion
              MyDrawerTile(
                title: "Deconnexion",
                icon: Icons.logout,
                onTap: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
