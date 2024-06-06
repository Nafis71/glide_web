import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:glide_web/themes/appbar_style.dart';
import 'package:glide_web/themes/textfield_style.dart';
import 'package:glide_web/utils/app_color.dart';
import 'package:glide_web/utils/routes.dart';
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
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        locale: DevicePreview.locale(context),
        builder: DevicePreview.appBuilder,
        initialRoute: Routes.homeScreen,
        onGenerateRoute: (routeSettings) {
          return Routes.generateRoute(routeSettings);
        },
        theme: ThemeData(
          scaffoldBackgroundColor: AppColor.scaffoldBackgroundColor,
          appBarTheme: AppbarStyle.getAppbarStyle(),
          inputDecorationTheme: TextFieldStyle.getTextFieldStyle(),
        ),
      ),
    );
  }
}
