import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto_flutter_epsi/components/my_input_alert_box.dart';
import 'package:tuto_flutter_epsi/helper/time_formatter.dart';
import 'package:tuto_flutter_epsi/services/auth/auth_service.dart';
import 'package:tuto_flutter_epsi/services/database/database_provider.dart';

import '../models/post.dart';

/*
 Post Tile = une case pour chaque post

 ---------------------------------------------------

 Pour chaque tile il me faut:
 - un post
 - une fonction pour rediriger sur le post quand on clique dessus
 - une fonction pour aller sur le profil de celui qui a posté quand on clique sur son nom

*/

class MyPostTile extends StatefulWidget {
  // Variables
  final Post post;
  final void Function()? onUserTap;
  final void Function()? onPostTap;

  const MyPostTile({
    super.key,
    required this.post,
    required this.onUserTap,
    required this.onPostTap,
  });

  @override
  State<MyPostTile> createState() => _MyPostTileState();
}

class _MyPostTileState extends State<MyPostTile> {
// providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  @override
  void initState() {
    super.initState();
    _loadComments();
  }

  /*
   LIKE
  */
// methode pour liker ou unliker
  void toggleLikePost() async {
    try {
      await databaseProvider.toggleLike(widget.post.id);
    } catch (e) {
      print(e);
    }
  }

  /*
  Commentaires
  */
  // controller
  final _commentController = TextEditingController();

  // boite de dialogue pour ajouter un nouveau commentaire
  void _openNewCommentBox() {
    showDialog(
      context: context,
      builder: (context) => MyInputAlertBox(
        textController: _commentController,
        hintText: 'Saisissez votre commentaire',
        onPressed: () async {
          await _addComment();
        },
        onPressedText: 'Publier',
      ),
    );
  }

  // Ajouter un commentaire
  Future<void> _addComment() async {
    // si le controller est vide, on ne fait rien
    if (_commentController.text.trim().isEmpty) return;

    try {
      await databaseProvider.addComment(
          widget.post.id, _commentController.text.trim());
    } catch (e) {
      print(e);
    }
  }

  // Charger les commentaires
  Future<void> _loadComments() async{
    await databaseProvider.loadComments(widget.post.id);
  }

  // method pour afficher les options d'un post
  void _showOptions() {
    // on vérifie si le post est celui de l'utilisateur connecté
    String currentUid = AuthService().getCurrentUid();
    final bool isOwnPost = widget.post.uid == currentUid;

    // fenêtre modale en bas
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                if (isOwnPost)

                  // supprimer si c'est le post de l'utilisateur connecté
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text("Supprimer"),
                    onTap: () async {
                      Navigator.pop(context);
                      await databaseProvider.deletePost(widget.post.id);
                    },
                  )
                else ...[
                  // signaler l'utilisateur si le post est celui de quelqu'un d'autre
                  ListTile(
                    leading: const Icon(Icons.flag),
                    title: const Text("Signaler"),
                    onTap: () async {
                      Navigator.pop(context);
                    },
                  ),

                  // bloquer l'utilisateur
                  ListTile(
                    leading: const Icon(Icons.block),
                    title: const Text("Bloquer"),
                    onTap: () async {
                      Navigator.pop(context);
                    },
                  ),
                ],

                // annuler
                ListTile(
                  leading: const Icon(Icons.cancel),
                  title: const Text("Annuler"),
                  onTap: () async {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          );
        });
  }

  // UI
  @override
  Widget build(BuildContext context) {
    /*
    Listeners
    * */
    // Est ce que l'utilisateur aime le post ?
    bool likedByCurrentUser =
        listeningProvider.isPostLikedByCurrentUser(widget.post.id);

    // Compteur de likes
    int likeCount = listeningProvider.getLikeCount(widget.post.id);

    // compteur de commentaires
    int commentCount = listeningProvider.getComments(widget.post.id).length;

    return GestureDetector(
      onTap: widget.onPostTap,
      child: Container(
        padding: EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
          borderRadius: BorderRadius.circular(8),
        ),

        // ligne en haut de la tile avec le nom de l'utilisateur => redirige sur le profil
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: widget.onUserTap,
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(width: 10),
                  Text(widget.post.name,
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      )),
                  const SizedBox(width: 4),
                  Text(
                    '@${widget.post.username}',
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  Spacer(),
                  GestureDetector(
                    onTap: _showOptions,
                    child: Icon(
                      Icons.more_horiz,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              widget.post.message,
              style: TextStyle(
                color: Theme.of(context).colorScheme.primary,
              ),
            ),

            const SizedBox(height: 20),

            // boutons like et commenter
            Row(
              children: [
                SizedBox(
                  width: 60,
                  child: Row(
                    children: [
                      // bouton like
                      GestureDetector(
                        onTap: toggleLikePost,
                        child: likedByCurrentUser
                            ? Icon(
                                Icons.favorite,
                                color: Colors.red,
                              )
                            : Icon(
                                Icons.favorite,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                      ),

                      SizedBox(
                        width: 5,
                      ),

                      // compteur de likes
                      Text(
                        likeCount != 0 ? likeCount.toString() : '',
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.primary,
                        ),
                      ),
                    ],
                  ),
                ),

                //bouton commenter
                Row(
                  children: [
                    // bouton commenter
                    GestureDetector(
                      onTap: _openNewCommentBox,
                      child: Icon(
                        Icons.comment,
                      ),
                    ),

                    SizedBox(
                      width: 5,
                    ),

                    // compteur de commentaires
                    Text(
                      commentCount != 0 ? commentCount.toString() : '',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  ],
                ),

                Spacer(),

                // timestamp
                Text(
                  formatTimestamp(widget.post.timestamp),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
