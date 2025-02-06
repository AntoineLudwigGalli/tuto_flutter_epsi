import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto_flutter_epsi/components/my_drawer.dart';
import 'package:tuto_flutter_epsi/components/my_input_alert_box.dart';
import 'package:tuto_flutter_epsi/components/my_post_tile.dart';
import 'package:tuto_flutter_epsi/helper/navigate_pages.dart';

import '../models/post.dart';
import '../services/database/database_provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  // Providers
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);
  late final listeningProvider = Provider.of<DatabaseProvider>(context);

  // controllers
  final _messageController = TextEditingController();

  // au démarrage
  @override
  void initState() {
    super.initState();

    loadAllPosts();
  }

  // charger tous les posts
  Future<void> loadAllPosts() async {
    await databaseProvider.loadAllPosts();
  }

  // boite de dialogue pour poster un message
  void _openPostMessageBox() {
    showDialog(
      context: (context),
      builder: (context) => MyInputAlertBox(
        textController: _messageController,
        hintText: "Exprimez-vous !",
        onPressed: () async {
          await postMessage(_messageController.text);
        },
        onPressedText: "Poster",
      ),
    );
  }

  // poster le message
  Future<void> postMessage(String message) async {
    await databaseProvider.postMessage(message);
  }

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
      floatingActionButton: FloatingActionButton(
        onPressed: _openPostMessageBox,
        // ouvre une fenetre de dialogue pour saisir mon message
        child: const Icon(Icons.add),
      ),

      // liste des posts
      body: _buildPostList(listeningProvider.allPosts),
    );
  }

  // affichage d'une liste à partir d'une liste de posts
  Widget _buildPostList(List<Post> posts) {
    return posts.isEmpty
        ? Center(
            child: Text(
              'Aucun post pour le moment',
            ),
          )
        : ListView.builder(
            itemCount: posts.length,
            itemBuilder: (context, index) {
              // récupère chaque post
              final post = posts[index];
              return MyPostTile(
                post: post,
                onUserTap: () => goUserPage(context, post.uid),
                onPostTap: () => goPostPage(context, post),
              );
            },
          );
  }
}
