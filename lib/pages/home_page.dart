import 'package:flutter/material.dart';
import 'package:tuto_flutter_epsi/components/my_drawer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  // Afficher UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Accueil",
        ),
      ),
      drawer: MyDrawer(),
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}
