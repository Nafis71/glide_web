import 'package:flutter/material.dart';
import 'package:glide_web/themes/app_text_style.dart';
import 'package:glide_web/themes/appbar_style.dart';
import 'package:glide_web/themes/textfield_style.dart';
import 'package:glide_web/utils/app_color.dart';
import 'package:glide_web/utils/routes.dart';
import 'package:glide_web/viewModels/news_view_model.dart';
import 'package:glide_web/viewModels/web_view_model.dart';
import 'package:provider/provider.dart';

class GlideWeb extends StatelessWidget {
  const GlideWeb({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => WebViewModel(),
        ),
        ChangeNotifierProvider(
          create: (context) => NewsViewModel(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        initialRoute: Routes.homeScreen,
        onGenerateRoute: (routeSettings) {
          return Routes.generateRoute(routeSettings);
        },
        theme: ThemeData(
          scaffoldBackgroundColor: AppColor.scaffoldBackgroundColor,
          appBarTheme: AppbarStyle.getAppbarStyle(),
          inputDecorationTheme: TextFieldStyle.getTextFieldStyle(),
          textTheme: AppTextStyle.getTextTheme()
        ),
      ),
    );
  }
}
