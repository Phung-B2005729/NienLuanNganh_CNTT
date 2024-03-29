// ignore_for_file: unused_local_variable

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'color.dart';

class AppTheme {
  // 1

  static TextTheme lightTextTheme = TextTheme(
    headlineLarge: GoogleFonts.openSans(
      fontSize: 18.0, //22.0
      fontWeight: FontWeight.w800,
      color: Colors.black,
    ),
    headlineMedium: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    headlineSmall: GoogleFonts.openSans(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.black,
    ),
    bodyLarge: GoogleFonts.openSans(
      fontSize: 20.0, //22.0
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    bodyMedium: GoogleFonts.openSans(
      fontSize: 18.0,
      fontWeight: FontWeight.w500,
      color: Colors.black,
    ),
    bodySmall: GoogleFonts.openSans(
      fontSize: 16.0,
      fontWeight: FontWeight.w400,
      color: Colors.black,
    ),
    displayLarge: GoogleFonts.openSans(
      fontSize: 32.0, //28
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    displayMedium: GoogleFonts.openSans(
      fontSize: 21.0, // 26
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    displaySmall: GoogleFonts.openSans(
      fontSize: 17.0,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    titleLarge: GoogleFonts.openSans(
      fontSize: 44.0, //30
      fontWeight: FontWeight.w700,
      color: ColorClass.fiveColor,
    ),
    titleMedium: GoogleFonts.openSans(
      fontSize: 24,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
    titleSmall: GoogleFonts.arizonia(
      //roboto
      // arizonia
      fontSize: 40,
      fontWeight: FontWeight.w700,
      color: Colors.black,
    ),
  );

  static ThemeData light() {
    return ThemeData(
      // useMaterial3: true,
      colorScheme: const ColorScheme.light(),
      dialogBackgroundColor: Colors.white,
      primaryColor: ColorClass.primaryColor,
      brightness: Brightness.light,
      checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStateColor.resolveWith(
          (states) {
            return Colors.black;
          },
        ),
      ),
      appBarTheme: const AppBarTheme(
        foregroundColor: Colors.black,
        backgroundColor: Colors.white,
        shadowColor: ColorClass.xanh1Color,
        centerTitle: true,
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        foregroundColor: Colors.white,
        backgroundColor: ColorClass.fiveColor,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        selectedItemColor: ColorClass.fiveColor,
      ),
      textTheme: lightTextTheme,
    );
  }
}
