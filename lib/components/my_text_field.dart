import 'package:flutter/material.dart';

/*

Text Field d'un formulaire

Un champ dans lequel mon utilisateur pourra écrire des choses

-------------------------------------------------------------------

Ce champ nécessite :
- text controller (qui permet d'accéder à ce que l'utilisateur a saisi)
- un hint text
- obscure text (booléen qui va cacher le contenu saisi par l'utilisateur quand il est true)

*/

class MyTextField extends StatelessWidget {
  // variables
  final TextEditingController controller;
  final String hintText;
  final bool obscureText;

  // constructeur
  const MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    required this.obscureText,
  });

  // UI
  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(

        // Bordure quand le champ est déselectionné
        enabledBorder:  OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.tertiary,
          ),
          borderRadius: BorderRadius.circular(12),
        ),

        // Bordure quand le champ est sélectionné
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Theme.of(context).colorScheme.primary,
          ),
          borderRadius: BorderRadius.circular(12),
        ),

        fillColor: Theme.of(context).colorScheme.secondary,
        filled: true,


        // Hint Text
        hintText: hintText,
        hintStyle: TextStyle(
          color: Theme.of(context).colorScheme.primary,
        ),

      ),
    );
  }
}
