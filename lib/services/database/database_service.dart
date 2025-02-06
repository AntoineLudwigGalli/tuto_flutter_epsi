/*

Service qui va gérer toutes les données vers et depuis Firestore

-----------------------------------------------------------------

- Profils utilisateurs
- posts
- Likes
- Commentaires
- Modération
- Suivre

*/

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:tuto_flutter_epsi/models/user.dart';
import 'package:tuto_flutter_epsi/services/auth/auth_service.dart';

import '../../models/post.dart';

class DatabaseService {
  // on récupère une instance de Firestore et de Auth
  final _auth = FirebaseAuth.instance;
  final _db = FirebaseFirestore.instance;

  /*

  PROFIL UTILISATEUR
  Quand on crée un compte Auth, on stocke également les données en bdd pour les afficher sur le profil

  */

  // Sauvegarder les données utilisateur
  Future<void> saveUserInfoInFirebase({required String name, email}) async {
    // récupère uid
    String uid = _auth.currentUser!.uid;

    // le username = ce qu'il y a avant @ dans l'adresse mail
    String username = email.split('@')[0];

    // crée le profil utilisateur
    UserProfile user = UserProfile(
      uid: uid,
      name: name,
      email: email,
      username: username,
      bio: '',
    );

    // Convertit le user en map pour le stocker dans firestore
    final userMap = user.toMap();

    // On enregistre les données en bdd
    await _db.collection('Users').doc(uid).set(userMap);
  }

// Récupérer les données utilisateur
  Future<UserProfile?> getUserFromFirebase(String uid) async {
    try {
      DocumentSnapshot userDoc = await _db.collection("Users").doc(uid).get();
      return UserProfile.fromDocument(userDoc);
    } catch (e) {
      print(e);
      return null;
    }
  }

  // Mettre à jour la bio
  Future<void> updateUserBioInFirebase(String bio) async {
    // ON récupère l'uid
    String uid = AuthService().getCurrentUid();

    // ON met à jour dans Firebase
    try {
      await _db.collection("Users").doc(uid).update({"bio": bio});
    } catch (e) {
      print(e);
    }
  }

/*
POSTS

*/

// Poster Un message
  Future<void> postMessageInFirebase(String message) async {
    try {
      // On récupère l'uid de l'utilisateur actuel
      String uid = _auth.currentUser!.uid;
      UserProfile? user = await getUserFromFirebase(uid);

      // on crée le nouveau post
      Post newPost = Post(
        id: '',
        uid: uid,
        name: user!.name,
        username: user.username,
        message: message,
        timestamp: Timestamp.now(),
        likeCount: 0,
        likedBy: [],
      );

      // on convertir en map et ajouter à la bdd
      Map<String, dynamic> newPostMap = newPost.toMap();
      await _db.collection("Posts").add(newPostMap);
    } catch (e) {
      print(e);
    }
  }

// Supprimer un message
  Future<void> deletePostFromFirebase(String postId) async {
    try {
      await _db.collection('Posts').doc(postId).delete();
    } catch (e) {
      print(e);
    }
  }

// Récupérer tous les posts
  Future<List<Post>> getAllPostsFromFirebase() async {
    try {
      QuerySnapshot snapshot = await _db
          .collection("Posts")
          .orderBy('timestamp', descending: true)
          .get();

      return snapshot.docs.map((doc) => Post.fromDocument(doc)).toList();
    } catch (e) {
      return [];
    }
  }

  /*
  LIKES

  */

// Like/unlike un post
Future<void> toggleLikeInFirebase(String postId) async {
  try{
    // répérer l'uid
    String uid = _auth.currentUser!.uid;
    // on va au doc du postId
    DocumentReference postDoc = _db.collection('Posts').doc(postId);

    // on fait le like
    await _db.runTransaction(
        (transaction) async {
          // récupère les données du post
          DocumentSnapshot postSnapshot = await transaction.get(postDoc);

          // récupère les likes des users qui ont liké et on crée une liste avec (liste de uids)
          List<String> likedBy = List<String>.from(postSnapshot['likedBy'] ?? []);

          // récupère le compteur de likes
          int currentLikeCount = postSnapshot['likes'];

          // Si l'utilisateur n'a pas encore liké le post -> on like
          if(!likedBy.contains(uid)) {
            // ajoute l'uid de l'utilisateur connecté à la liste likedBy
            likedBy.add(uid);

            // on incremente le compteur de likes
            currentLikeCount++;
          } else {
            // si l'utilisateur a déjà liké le post -> on enlève son uid de la likedBy list
            likedBy.remove(uid);
            // on décrémente le compteur de like
            currentLikeCount--;
          }

          // on met à jour Firebase
          transaction.update(
            postDoc, {
            'likes': currentLikeCount,
            'likedBy': likedBy,
          });
        },
    );
  } catch (e) {
    print(e);
  }
}



}
