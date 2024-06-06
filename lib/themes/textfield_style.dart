import 'package:flutter/material.dart';
import 'package:glide_web/utils/app_color.dart';

class TextFieldStyle{
  static InputDecorationTheme getTextFieldStyle()=> InputDecorationTheme(
      fillColor: AppColor.webScreenTextFieldColor,
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