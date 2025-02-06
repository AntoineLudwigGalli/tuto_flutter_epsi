import 'package:flutter/material.dart';
import 'package:tuto_flutter_epsi/helper/navigate_pages.dart';

import '../components/my_post_tile.dart';
import '../models/post.dart';
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
  @override
  Widget build(BuildContext context) {
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

          // commentaires
        ],
      ),
    );
  }
}
