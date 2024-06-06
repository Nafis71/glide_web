import 'package:flutter/material.dart';
import 'package:glide_web/utils/app_color.dart';

class AppbarStyle{
  static AppBarTheme getAppbarStyle() => AppBarTheme(
    backgroundColor: AppColor.appBarBackgroundColor,
    foregroundColor: AppColor.appBarForegroundColor,
    surfaceTintColor: AppColor.appBarBackgroundColor,
    elevation: 10
  );
}