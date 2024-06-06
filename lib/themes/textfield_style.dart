import 'package:flutter/material.dart';

class TextFieldStyle{
  static InputDecorationTheme getTextFieldStyle()=> InputDecorationTheme(
      fillColor: Colors.green.shade100,
      filled: true,
      enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(30)
      ),
    focusedBorder: OutlineInputBorder(
        borderSide: BorderSide.none,
        borderRadius: BorderRadius.circular(30)
    ),
    contentPadding: const EdgeInsets.all(6)
  );
}