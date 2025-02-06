import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto_flutter_epsi/components/my_comment_tile.dart';
import 'package:tuto_flutter_epsi/helper/navigate_pages.dart';

import '../components/my_post_tile.dart';
import '../models/post.dart';
import '../services/database/database_provider.dart';
/*

Page d'un post en particulier avec ses commentaires

*/

class PostPage extends StatefulWidget {
  final Post post;

  const PostPage({
    super.key,
    required this.post,
  });

  @override
  State<PostPage> createState() => _PostPageState();
}

class _PostPageState extends State<PostPage> {
  // providers
  late final listeningProvider = Provider.of<DatabaseProvider>(context);
  late final databaseProvider =
      Provider.of<DatabaseProvider>(context, listen: false);

  // UI
  @override
  Widget build(BuildContext context) {
    // listeners
    final allComments = listeningProvider.getComments(widget.post.id);

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        foregroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: ListView(
        children: [
          MyPostTile(
            post: widget.post,
            onUserTap: () => goUserPage(context, widget.post.uid),
            onPostTap: () {},
          ),
          allComments.isEmpty
              ? // pas de commentaire
              Center(
                  child: Text("Pas de commentaire"),
                )
              :
              // commentaires
              ListView.builder(
                  itemCount: allComments.length,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemBuilder: (context, index) {
                    // récupérer chaque commentaire
                    final comment = allComments[index];
                    return MyCommentTile(
                      comment: comment,
                      onUserTap: () => goUserPage(
                        context,
                        comment.uid,
                      ),
                    );
                  },
                ),
        ],
      ),
    );
  }
}
