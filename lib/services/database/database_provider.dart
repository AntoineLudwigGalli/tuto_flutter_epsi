import 'package:flutter/foundation.dart';
import 'package:tuto_flutter_epsi/services/auth/auth_service.dart';
import 'package:tuto_flutter_epsi/services/database/database_service.dart';
import '../../models/comment.dart';
import '../../models/post.dart';
import '../../models/user.dart';

/*

Database provider

Sert à séparer la gestion des données Firestore de la manière dont elles sont affichées sur l'UI

- le database service s'occupe de gérer les données de la bdd
- le database provider organise et affiche les données

Ca permet de rendre le code plus adaptable, lisible, facile à tester, propre et sûr.

Si on choisit de faire évoluer le backend, le frontend interagissant avec ce provider et non avec le service en direct,
on aura à faire évoluer uniquement les interactions service <-> provider simplifiant ainsi la transition et la maintenance

*/

class DatabaseProvider extends ChangeNotifier{

  // On récupère la bdd et l'auth
  final _auth = AuthService();
  final _db = DatabaseService();

  /*
   Profil utilisateur

  */

  // on récupère le profil utilisateur grâce à l'uid
  Future<UserProfile?> userProfile(String uid) => _db.getUserFromFirebase(uid);

// MàJ de la bio
Future<void> updateBio(String bio) => _db.updateUserBioInFirebase(bio);


/*
Posts

*/

// lister les posts locaux
List<Post> _allPosts = [];

// récupère tous les posts en local
List<Post> get allPosts => _allPosts;

// récupère les posts depuis Firebase
  Future<void> loadAllPosts() async {
    final allPosts = await _db.getAllPostsFromFirebase();

    // met à jour les posts locaux
    _allPosts = allPosts;

    // mise à jour des likes en local
    initializeLikeMap();

    // MàJ de l'UI
    notifyListeners();

  }

  // filtrer et récupérer les posts d'un utilisateur
  List<Post> filterUserPosts(String uid) {
    return _allPosts.where((post) => post.uid == uid).toList();
  }

// poster un message
Future<void> postMessage(String message) async {
  // on poste le message sur Firebase
  await _db.postMessageInFirebase(message);

  // on recharge les données depuis Firebase
  loadAllPosts();
}

// supprimer un message
Future<void> deletePost(String postId) async {
    await _db.deletePostFromFirebase(postId);

    await loadAllPosts();
}

/*
LIKES
*/

// Local map pour suivre le compte de likes sur chaque post
Map<String, int> _likeCounts = {}; // pour chaque postId => un like count

// Liste locale pour suivre les posts likés par l'utilisateur actuel
List<String> _likedPosts = [];

// est ce que l'utilisateur actuel a liké ce post ?
bool isPostLikedByCurrentUser(String postId) => _likedPosts.contains(postId);

// récupère le compteur de likes du post
int getLikeCount(String postId) => _likeCounts[postId] ?? 0;

// initialise la like map localement
void initializeLikeMap() {
  // récupère l'uid
  final currentUserId = _auth.getCurrentUid();

  // efface les posts likés localement pour remettre à 0 quand un nouvel utilisateur se connecte
  _likedPosts.clear();

  // récupérer les données de like pour chaque post
  for (var post in _allPosts){
    // Maj like count map local
    _likeCounts[post.id] = post.likeCount;

    // si l'utilisateur a déjà liké le post
    if(post.likedBy.contains(currentUserId)){
      // ajoute le post id à la liste locale des posts likés
      _likedPosts.add(post.id);

    }

  }
}

// methode toggle like
Future<void> toggleLike(String postId) async {
  /*
  Méthode en plusieurs parties :
  - 1ere partie va mettre à jour les données en local afin d'avoir une UI réactive et performante
  sans impression de lag ou de lenteur pour l'utilisateur
  - 2e partie va mettre à jour et récupérer les données réelles depuis la base de données
  S'il y a un soucis avec la bdd, on remet l'UI dans son état originel

  */

  // AU cas ou la liaison avec la bdd a un soucis, on commence par stocker les données
  // à envoyer en local
  final likedPostOriginal = _likedPosts;
  final likeCountsOriginal = _likeCounts;

  // réaliser action like ou unlike
  if(_likedPosts.contains(postId)) {
    _likedPosts.remove(postId);
    _likeCounts[postId] = (_likeCounts[postId] ?? 0) - 1;
  } else {
    _likedPosts.add(postId);
    _likeCounts[postId] = (_likeCounts[postId] ?? 0) + 1;
  }

  // maj l'UI
  notifyListeners();

  // on essaie de mettre à jour les données en bdd (invisible pour l'utilisateur)
  try{
    await _db.toggleLikeInFirebase(postId);
  } catch(e) {
    // revenir à l'état initial de l'UI s'il y a un soucis avec la bdd
    _likedPosts = likedPostOriginal;
    _likeCounts = likeCountsOriginal;

    notifyListeners();
  }
}

/*
Commentaires
*/
// liste locale de commentaires
final Map<String, List<Comment>> _comments = {};

// récupère les commentaires en local
List<Comment> getComments(String postId) => _comments[postId] ?? [];

// récupérer les commentaires associés au post depuis la bdd
Future<void> loadComments(String postId) async {
  // récupère tous les commentaires associés à cce post
  final allComments = await _db.getCommentsFromFirebase(postId);

  // maj des données locales
  _comments[postId] = allComments;

  // maj UI
  notifyListeners();
}

// Ajouter un commentaire
Future<void> addComment(String postId, message) async {
  await _db.addCommentInFirebase(postId, message);
  await loadComments(postId);
}

// Supprimer un commentaire
Future<void> deleteComments(String commentId, postId) async {
  await _db.deleteCommentInFirebase(commentId);
  await loadComments(postId);
}

}