import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../helper/time_formatter.dart';
import '../models/comment.dart';
import '../services/auth/auth_service.dart';
import '../services/database/database_provider.dart';

/*

Tuile commentaire

Affiche un commentaire sous un post

-------------------------------------------------------------
A besoin de :
- un commentaire
- une fonction (redirige sur le profil du compte qui a posté le commentaire)

*/

class MyCommentTile extends StatelessWidget {
  final Comment comment;
  final void Function()? onUserTap;

  const MyCommentTile({
    super.key,
    required this.comment,
    required this.onUserTap,
  });


  // method pour afficher les options d'un post
  void _showOptions(BuildContext context) {
    // on vérifie si le post est celui de l'utilisateur connecté
    String currentUid = AuthService().getCurrentUid();
    final bool isOwnComment = comment.uid == currentUid;

    // fenêtre modale en bas
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return SafeArea(
            child: Wrap(
              children: [
                if (isOwnComment)

                // supprimer si c'est le post de l'utilisateur connecté
                  ListTile(
                    leading: const Icon(Icons.delete),
                    title: const Text("Supprimer"),
                    onTap: () async {
                      Navigator.pop(context);
                      await Provider.of<DatabaseProvider>(
                          context, listen: false).deleteComments(
                          comment.id, comment.postId);
                    },
                  )
                else
                  ...[
                    // signaler l'utilisateur si le commentaire est celui de quelqu'un d'autre
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
      return Container(
        padding: EdgeInsets.all(20),
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 5),
        decoration: BoxDecoration(
          color: Theme
              .of(context)
              .colorScheme
              .secondary,
          borderRadius: BorderRadius.circular(8),
        ),

        // ligne en haut de la tile avec le nom de l'utilisateur => redirige sur le profil
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            GestureDetector(
              onTap: onUserTap,
              child: Row(
                children: [
                  Icon(
                    Icons.person,
                    color: Theme
                        .of(context)
                        .colorScheme
                        .primary,
                  ),

                  const SizedBox(width: 10),

                  Text(
                    comment.name,
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(width: 4),

                  Text(
                    '@${comment.username}',
                    style: TextStyle(
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                    ),
                  ),

                  Spacer(),
                  // options
                  GestureDetector(
                    onTap: () => _showOptions(context),
                    child: Icon(
                      Icons.more_horiz,
                      color: Theme
                          .of(context)
                          .colorScheme
                          .primary,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Text(
              comment.message,
              style: TextStyle(
                color: Theme
                    .of(context)
                    .colorScheme
                    .primary,
              ),
            ),

            // timestamp
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Text(
                  formatTimestamp(comment.timestamp),
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }
  }
