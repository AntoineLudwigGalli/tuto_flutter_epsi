import 'package:flutter/material.dart';
import 'package:tuto_flutter_epsi/services/auth/auth_service.dart';
import 'package:tuto_flutter_epsi/services/database/database_service.dart';

import '../components/my_button.dart';
import '../components/my_text_field.dart';

/*

Page d'inscription

Un formulaire permettant de créer un compte utilisateur

--------------------------------------------------------

On a besoin de :
- nom
- email
- mot de passe
- confirmation du mot de passe

*/

class RegisterPage extends StatefulWidget {
  // Variables
  final void Function()? onTap;

  const RegisterPage({super.key, required this.onTap});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  // auth service
  final _auth = AuthService();

  // db service
  final _db = DatabaseService();

  // Text controllers
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // méthode pour créer un compte
  void register() async {
    // si le mot de passe et la confirmation sont identiques, on crée l'utilisateur
    if (passwordController.text == confirmPasswordController.text) {
      try {
        // on crée le compte dans Auth
        await _auth.registerEmailPassword(
          emailController.text,
          passwordController.text,
        );

        // Si le compte est bien créé dans Auth, on enregistre les données utilisateur en bdd
        await _db.saveUserInfoInFirebase(
          name: nameController.text,
          email: emailController.text,
        );

      } catch (e) {
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text(e.toString()),
            ),
          );
        }
      }
      // si le mot de passe et la confirmation sont différents
    } else {
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text(
            "Les mots de passe ne correspondent pas",
          ),
        ),
      );
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo
              Icon(
                Icons.lock_open_rounded,
                size: 60,
                color: Theme.of(context).colorScheme.primary,
              ),

              const SizedBox(height: 40),

              // Message de bienvenue
              Text(
                "Créez votre compte",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),

              // Champ nom
              MyTextField(
                controller: nameController,
                hintText: 'Saisissez votre nom...',
                obscureText: false,
              ),
              const SizedBox(height: 15),
              // Champ email
              MyTextField(
                controller: emailController,
                hintText: 'Saisissez votre email...',
                obscureText: false,
              ),
              const SizedBox(height: 15),

              // Champ mot de passe
              MyTextField(
                controller: passwordController,
                hintText: 'Saisissez votre mot de passe...',
                obscureText: true,
              ),

              const SizedBox(height: 15),

              // Champ confirmation mot de passe
              MyTextField(
                controller: confirmPasswordController,
                hintText: 'Confirmez votre mot de passe...',
                obscureText: true,
              ),

              const SizedBox(height: 25),

              // Bouton d'action Créer le compte
              MyButton(
                text: "Créez votre compte",
                onTap: register,
              ),

              const SizedBox(height: 30),

              // Lien vers la register page Login
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Déjà membre ?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Connectez-vous!",
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
