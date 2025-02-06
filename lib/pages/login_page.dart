import 'package:flutter/material.dart';
import 'package:tuto_flutter_epsi/components/my_button.dart';
import 'package:tuto_flutter_epsi/components/my_text_field.dart';
import 'package:tuto_flutter_epsi/services/auth/auth_service.dart';

/*

Page de connexion
Un utilisateur existant peut se connecter avec

- email
- mot de passe

---------------------------------------------------------------------

Si l'utilisateur est authentifié => redirection vers Home Page
Si l'utilisateur n'existe pas encore => affiche un lien qui redirige vers la page de création de compte (register page)

*/

class LoginPage extends StatefulWidget {
  // Variables
  final void Function()? onTap;

  // Constructeur
  const LoginPage({
    super.key,
    required this.onTap,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  // Auth Service
  final _auth = AuthService();

  // Text controllers
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // méthode de connexion
  void login() async {
    try {
      // on essaie de se connecter avec les infos données par l'utilisateur
      await _auth.loginEmailPassword(
          emailController.text, passwordController.text);
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
                "Nous sommes heureux de vous revoir !",
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                  fontSize: 16,
                ),
              ),
              const SizedBox(height: 5),

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

              const SizedBox(height: 10),

              // Mot de passe oublié
              Align(
                alignment: Alignment.centerRight,
                child: Text(
                  "Mot de passe oublié ?",
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 25),

              // Bouton d'action Connexion
              MyButton(
                text: "Connexion",
                onTap: login,
              ),

              const SizedBox(height: 30),

              // Lien vers la register page Créer un compte
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Pas encore de compte ?",
                    style: TextStyle(
                      color: Theme.of(context).colorScheme.primary,
                    ),
                  ),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: widget.onTap,
                    child: Text(
                      "Créez un compte !",
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
