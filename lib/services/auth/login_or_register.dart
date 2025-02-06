import 'package:flutter/material.dart';

import '../../pages/login_page.dart';
import '../../pages/register_page.dart';

/*

Ce service va déterminer si on doit afficher la login page ou la register page

*/

class LoginOrRegister extends StatefulWidget {
  const LoginOrRegister({super.key});

  @override
  State<LoginOrRegister> createState() => _LoginOrRegisterState();
}

class _LoginOrRegisterState extends State<LoginOrRegister> {
  // Par défaut on va afficher la page de connexion
  bool showLoginPage = true;

  // Toggle en login et register page
  void togglePages() {
    setState(() {
      showLoginPage = !showLoginPage;
    });
  }

  // UI
  @override
  Widget build(BuildContext context) {
    if(showLoginPage) {
      return LoginPage(
        onTap: togglePages,
      );
    } else {
      return RegisterPage(
        onTap: togglePages,
      );
    }
  }
}
