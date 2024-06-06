import 'package:flutter/material.dart';

class AppTextStyle{
  static TextTheme getTextTheme() => const TextTheme(
    titleLarge: TextStyle(
      color: Colors.black,
      fontSize: 18,
      fontWeight: FontWeight.bold
    )
  );
}