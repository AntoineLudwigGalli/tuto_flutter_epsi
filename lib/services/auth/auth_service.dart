/*

Service Auth Firebase

Gère l'authentication des utilisateurs dans Firebase Auth

-------------------------------------------------------------

- Connexion
- Déconnexion
- Création d'un compte
- Suppression d'un compte

*/

import 'package:firebase_auth/firebase_auth.dart';

class AuthService{

  // Récupérer l'instance de auth
  final _auth = FirebaseAuth.instance;

  // Récupérer le user actuel et son uid
  User? getCurrentUser() => _auth.currentUser;

  String getCurrentUid() => _auth.currentUser!.uid;

// Connexion par Email et mot de passe
Future<UserCredential> loginEmailPassword(String email, password) async {
  // tentative de connexion
  try{
   final userCredential = await _auth.signInWithEmailAndPassword(email: email, password: password);
   return userCredential;
   // on récupère les erreurs
  } on FirebaseAuthException catch(e){
    throw Exception(e.code);
  }
}


  // Déconnexion
Future<void> logout() async {
  await _auth.signOut();
}

  // Création du compte
Future<UserCredential> registerEmailPassword(String email, password) async {
  try{
    UserCredential userCredential = await _auth.createUserWithEmailAndPassword(email: email, password: password);
    return userCredential;

  } on FirebaseAuthException catch(e){
  throw Exception(e.code);
  }
}

  // Suppression du compte


}