import 'package:flutter/material.dart';

class AppTema {
  static get theme {
    return ThemeData(
      fontFamily: 'Roboto',
      scaffoldBackgroundColor: Colors.black,
      cardTheme: CardThemeData(
        elevation: 0,
        color: Color.fromARGB(255, 14, 14, 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
      ),
      textTheme: TextTheme(
        //Nome Empresa
        titleMedium: TextStyle(
            color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
        //Endereço Empresa
        titleSmall: TextStyle(fontSize: 12, color: Colors.grey[200]),
        //Titulo em cima do card
        headlineMedium: TextStyle(fontSize: 14, color: Colors.grey[400]),

        labelLarge: TextStyle(fontSize: 18, color: Colors.grey[200]),
        labelMedium: TextStyle(fontSize: 12, color: Colors.grey[200]),
        labelSmall: TextStyle(fontSize: 12, color: Colors.grey[400]),
      ),
      //Botões grandes
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Color.fromARGB(255, 36, 36, 39),
          padding: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color:
            Colors.orange, 
      ),
      colorScheme: ColorScheme.fromSwatch()
          .copyWith(secondary: Colors.orange)
          .copyWith(surface: Colors.grey[200])
          .copyWith(surfaceBright: Colors.grey[400])
          .copyWith(primary: Colors.black)
          .copyWith(primaryContainer: Color.fromARGB(255, 36, 36, 39)),
    );
  }
}

/*

Color(0xFFF68F32)
this.displayLarge,
    this.displayMedium,
    this.displaySmall,
    this.headlineLarge,
    this.headlineMedium,
    this.headlineSmall,
    this.titleLarge,
    this.titleMedium,
    this.titleSmall,
    this.bodyLarge,
    this.bodyMedium,
    this.bodySmall,
    this.labelLarge,
    this.labelMedium,
    this.labelSmall,
*/
