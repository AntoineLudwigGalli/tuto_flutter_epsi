import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:tuto_flutter_epsi/pages/login_page.dart';
import 'package:tuto_flutter_epsi/services/auth/login_or_register.dart';

import '../../pages/home_page.dart';

/*

Auth Gate

Vérifie si l'utilisateur est connecté ou non

---------------------------------------------

Connecté => redirige en Home Page
Non connecté => on redirige sur Login


*/

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(stream: FirebaseAuth.instance.authStateChanges(), builder: (context, snapshot){
        // Utilisateur connecté
        if(snapshot.hasData){
          return const HomePage();
        } else {
          return LoginOrRegister();
        }
      }),
    );
  }
}
