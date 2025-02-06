import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/database/database_provider.dart';

/*

Page de recherche d'un utilisateur

*/

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  // ocntrollers
  final _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    // providers
    final databaseProvider =
        Provider.of<DatabaseProvider>(context, listen: false);
    final listeningProvider = Provider.of<DatabaseProvider>(context);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          decoration: InputDecoration(
            hintText: 'Rechercher un utlisateur',
            hintStyle: TextStyle(
              color: Theme.of(context).colorScheme.primary,
            ),
            border: InputBorder.none,
          ),
        ),
      ),
      body: Container(
        child: Text(
          "Résultats de la recherche",
        ),
      ),
    );
  }
}
