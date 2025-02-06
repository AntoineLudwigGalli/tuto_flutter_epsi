import 'package:cloud_firestore/cloud_firestore.dart';

/*
Modèle de données d'un utilisateur

--------------------------------------------------

Un utilisateur est composé de :

- uid
- nom
- email
- pseudo
- biographie
- photo de profil

*/


class UserProfile {
  final String uid;
  final String name;
  final String email;
  final String username;
  final String bio;

  UserProfile({
    required this.uid,
    required this.name,
    required this.email,
    required this.username,
    required this.bio,
  });

  // conversion d'un document firestore en modèle de données User
  factory UserProfile.fromDocument(DocumentSnapshot doc) {
    return UserProfile(
      uid: doc['uid'],
      name: doc['name'],
      email: doc['email'],
      username: doc['username'],
      bio: doc['bio'],
    );
  }

// conversion d'un modèle de données User en document Firetore
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'username': username,
      'bio': bio,
    };
  }
}
