import 'package:flutter/material.dart';

/*

Un bouton classique

------------------------------------

Nécessite:
- un texte
- une fonction quand on clique dessus (tap)

*/

class MyButton extends StatelessWidget {
  // variables
  final String text;
  final void Function()? onTap;

  //constructeur
  const MyButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  // UI
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(25),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.secondary,
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
