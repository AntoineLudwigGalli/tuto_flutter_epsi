import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tuto_flutter_epsi/pages/home_page.dart';
import 'package:tuto_flutter_epsi/pages/settings_page.dart';
import 'package:tuto_flutter_epsi/themes/light_mode.dart';
import 'package:tuto_flutter_epsi/themes/theme_provider.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SettingsPage(),
      theme: Provider.of<ThemeProvider>(context).themeData,
    );
  }
}
