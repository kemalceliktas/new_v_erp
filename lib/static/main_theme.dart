import 'package:flutter/material.dart';

import 'main_colors.dart';
import 'main_text_styles.dart';

class MainTheme{
  static final ThemeData notionThemeData = ThemeData(
  primaryColor: MainColors.notionPrimaryColor,
  // ignore: deprecated_member_use
  backgroundColor: MainColors.notionBackgroundColor,
  scaffoldBackgroundColor: MainColors.notionBackgroundColor,

  appBarTheme: const AppBarTheme(
    foregroundColor: MainColors.notionPrimaryColor,
    backgroundColor: MainColors.notionBackgroundColor,
    elevation: 0,
    iconTheme: IconThemeData(color: MainColors.notionIconColor),
    // ignore: deprecated_member_use
    textTheme: TextTheme(
      titleLarge: MainTextStyles.titleTextStyle,
    ),
  ),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white, backgroundColor: MainColors.notionAccent,
      textStyle: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.bold,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.symmetric(vertical: 0),
    ),
  ),
  popupMenuTheme: const PopupMenuThemeData(
    position: PopupMenuPosition.under,
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(4),
        topRight: Radius.circular(4),
      ),
    ),
  ),

  textButtonTheme: TextButtonThemeData(
    style: TextButton.styleFrom(
      foregroundColor: MainColors.notionAccent, textStyle: const TextStyle(
        color: MainColors.notionAccent,
        fontWeight: FontWeight.bold,
      ),
    ),
  ),
  listTileTheme: ListTileThemeData(
    tileColor: Colors.grey[200], // tile rengi
    selectedTileColor: Colors.blue[200], // seçili tile rengi
    // tile metin rengi
    selectedColor: Colors.white, // seçili tile metin rengi
    iconColor: Colors.black, // icon rengi

    contentPadding: const EdgeInsets.symmetric(
        vertical: 8.0, horizontal: 16.0), // tile içerik padding değerleri
  ),
  floatingActionButtonTheme: const FloatingActionButtonThemeData(
    backgroundColor: MainColors.notionPrimary,
    foregroundColor: MainColors.notionAccent,
  ),
  bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: MainColors.notionBackgroundColor,
      selectedIconTheme: IconThemeData(
        color: MainColors.notionPrimary,
      ),
      unselectedIconTheme: IconThemeData(
        color: MainColors.notionPrimary,
      )),
  inputDecorationTheme: InputDecorationTheme(
    filled: true,
    fillColor: Colors.white,
    labelStyle: const TextStyle(
      color: MainColors.notionPrimary,
    ),
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: BorderSide.none,
    ),
    focusedBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(16),
      borderSide: const BorderSide(
        color: MainColors.notionAccent,
        width: 2,
      ),
    ),
    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
  ),
  textTheme: TextTheme(
    displayLarge: MainTextStyles.titleTextStyle.copyWith(fontSize: 56.0, color: MainColors.notionPrimary),
    displayMedium:
        MainTextStyles.titleTextStyle.copyWith(fontSize: 48.0, color: MainColors.notionPrimary),
    displaySmall: MainTextStyles.titleTextStyle.copyWith(fontSize: 40.0, color: MainColors.notionPrimary),
    headlineMedium:
        MainTextStyles.titleTextStyle.copyWith(fontSize: 32.0, color: MainColors.notionPrimary),
    headlineSmall:
        MainTextStyles.titleTextStyle.copyWith(fontSize: 24.0, color: MainColors.notionPrimary),
    titleLarge: MainTextStyles.titleTextStyle,
    bodyLarge: MainTextStyles.bodyTextStyle,
    bodyMedium: MainTextStyles.bodyTextStyle.copyWith(fontSize: 14.0, color: MainColors.notionPrimary),

    // Diğer TextStylle özellikleri burada
  ),
);



}

