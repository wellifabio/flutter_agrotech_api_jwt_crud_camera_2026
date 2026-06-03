import 'package:flutter/material.dart';
import 'colors.dart';

abstract class AppTheme {
  static ThemeData appTheme = ThemeData.light().copyWith(
    scaffoldBackgroundColor: AppColors.p4,
    primaryColor: AppColors.p1,
    appBarTheme: AppBarTheme(
      backgroundColor: AppColors.p1,
      foregroundColor: AppColors.p4,
      titleTextStyle: TextStyle(
        fontFamily: 'PatrickHand',
        color: AppColors.p4,
        fontSize: 26,
        fontWeight: FontWeight.bold,
      ),
    ),
    textTheme: TextTheme(
      bodyMedium: TextStyle(
        fontFamily: 'PatrickHand',
        color: AppColors.p3,
        fontSize: 16,
      ),
      displayMedium: TextStyle(
        fontFamily: 'PatrickHand',
        color: AppColors.p3,
        fontSize: 16,
      ),
      labelMedium: TextStyle(
        fontFamily: 'PatrickHand',
        color: AppColors.p3,
        fontSize: 16,
      ),
      titleMedium: TextStyle(
        fontFamily: 'PatrickHand',
        color: AppColors.p3,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.p2,
        foregroundColor: AppColors.p4,
        textStyle: TextStyle(fontFamily: 'PatrickHand', fontSize: 22),
        elevation: 5,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),
    dialogTheme: DialogThemeData(
      backgroundColor: AppColors.p4,
      titleTextStyle: TextStyle(
        fontFamily: 'PatrickHand',
        color: AppColors.p1,
        fontSize: 22,
        fontWeight: FontWeight.bold,
      ),
      contentTextStyle: TextStyle(
        fontFamily: 'PatrickHand',
        color: AppColors.p2,
        fontSize: 16,
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: AppColors.p4,
      hintStyle: TextStyle(
        fontFamily: 'PatrickHand',
        color: AppColors.p2,
        fontSize: 16,
      ),
      labelStyle: TextStyle(
        fontFamily: 'PatrickHand',
        color: AppColors.p1,
        fontSize: 16,
      ),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.p3, width: 2),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.p2, width: 2),
      ),
    ),
    textSelectionTheme: TextSelectionThemeData(
      cursorColor: AppColors.p1,
      selectionColor: AppColors.p2,
      selectionHandleColor: AppColors.p2,
    ),
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(
        foregroundColor: AppColors.p1,
        textStyle: TextStyle(
          fontFamily: 'PatrickHand',
          fontSize: 16,
          fontWeight: FontWeight.bold,
        ),
      ),
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(
      backgroundColor: AppColors.p4,
      shape: CircleBorder(),
    ),
  );
}
