import 'package:flutter/material.dart';
/*

Un textfield dans une boite de dialogue pour saisir du texte

----------------------------------------------------------------------

On a besoin de
        - text controller
        - hintText
        - Fonction (sauvegarde par exemple)
        - Le texte du bouton qui ance la fonction

*/

class MyInputAlertBox extends StatelessWidget {
  // Variables
  final TextEditingController textController;
  final String hintText;
  final void Function()? onPressed;
  final String onPressedText;

  const MyInputAlertBox({
    super.key,
    required this.textController,
    required this.hintText,
    required this.onPressed,
    required this.onPressedText,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(Radius.circular(8)),
      ),
      backgroundColor: Theme.of(context).colorScheme.surface,
      content: TextField(
        controller: textController,
        maxLength: 280,
        maxLines: 3,
        decoration: InputDecoration(
          // bordure quand l'input est déselectionné
          enabledBorder: OutlineInputBorder(
            borderSide:
                BorderSide(color: Theme.of(context).colorScheme.tertiary),
            borderRadius: BorderRadius.circular(12),
          ),

          // bordure quand l'input est sélectionné
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary,
            ),
            borderRadius: BorderRadius.circular(12),
          ),

          // hintText
          hintText: hintText,
          hintStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),

          // couleur de fond
          fillColor: Theme.of(context).colorScheme.secondary,
          filled: true,

          // compteur de caractères
          counterStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
      ),
      actions: [
        // Bouton Enregistrer
        TextButton(
          onPressed: () {
            Navigator.pop(context);

            onPressed!();

            textController.clear();
          },
          child: Text(onPressedText),
        ),

        // bouton annuler
        TextButton(
          onPressed: () {
            Navigator.pop(context);
            textController.clear();
          },
          child: Text("Annuler"),
        ),
      ],
    );
  }
}
