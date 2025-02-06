import 'package:flutter/material.dart';
import 'package:tuto_flutter_epsi/pages/profile_page.dart';
import 'package:tuto_flutter_epsi/pages/settings_page.dart';
import 'package:tuto_flutter_epsi/services/auth/auth_service.dart';

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
  MyDrawer({super.key});

  // auth service
  final _auth = AuthService();

  // fonction déconnexion
  void logout() {
    _auth.logout();
  }

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
                onTap: () {
                  Navigator.pop(context);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          ProfilePage(uid: _auth.getCurrentUid()),
                    ),
                  );
                },
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
                onTap: () {
                  Navigator.pop(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => SettingsPage(),
                    ),
                  );
                },
              ),

              // Déconnexion
              MyDrawerTile(
                title: "Deconnexion",
                icon: Icons.logout,
                onTap: logout,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
