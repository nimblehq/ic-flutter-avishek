import 'package:flutter/material.dart';
import 'package:flutter_survey/gen/fonts.gen.dart';
import 'package:flutter_survey/theme/app_colors.dart';

class AppTheme {
  AppTheme._();

  static ThemeData get light => ThemeData(
        fontFamily: FontFamily.neuzeit,
        textTheme: const TextTheme(
          bodySmall: TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.normal,
          ),
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.normal,
          ),
          bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontWeight: FontWeight.normal,
          ),
          titleSmall: TextStyle(
            color: Colors.white,
            fontSize: 13,
            fontWeight: FontWeight.bold,
          ),
          headlineMedium: TextStyle(
            color: Colors.white,
            fontSize: 34,
            fontWeight: FontWeight.bold,
          ),
          headlineSmall: TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
          labelLarge: TextStyle(
            color: AppColors.blackRussian,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
        ),
      );
}
