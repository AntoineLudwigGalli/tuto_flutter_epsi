import 'package:flutter/material.dart';

import 'dark_mode.dart';
import 'light_mode.dart';

class ThemeProvider with ChangeNotifier{

  // Light mode par défaut
  ThemeData _themeData = lightMode;

  // On récupère le thème actif
ThemeData get themeData => _themeData;

// Est-on en DarkMode
bool get isDarkMode => _themeData == darkMode;

// on actualise le thème
set themeData (ThemeData themeData){
  _themeData = themeData;

  // on met à jour l'affichage de l'UI
  notifyListeners();
}

// Methode pour changer le thème
void toggleTheme(){
  if(_themeData == lightMode){
    themeData = darkMode;
  } else {
    themeData = lightMode;
  }
}


}