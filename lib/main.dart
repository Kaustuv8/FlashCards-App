import 'package:flashcards/screens/mainmenu.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter/services.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  
  ThemeData theme = ThemeData(
    textTheme: GoogleFonts.merriweatherTextTheme(),
    colorScheme: ColorScheme.fromSeed(seedColor: const Color.fromARGB(255, 0, 21, 255)),
  );


  runApp(MaterialApp(
    theme: theme,
    home: const StartingScreen(),
  ));
}


