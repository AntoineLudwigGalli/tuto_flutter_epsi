import 'package:flutter/material.dart';
import 'package:tuto_flutter_epsi/pages/profile_page.dart';

import '../models/post.dart';
import '../pages/post_page.dart';

// aller à la page de profil d'un utilisateur
void goUserPage(BuildContext context, String uid) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ProfilePage(uid: uid),
    ),
  );
}

// aller sur le détail d'un post
void goPostPage(BuildContext context, Post post) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => PostPage(
        post: post,
      ),
    ),
  );
}
