import 'package:flutter/material.dart';
import 'package:glide_web/views/homeScreen/home_screen.dart';
import 'package:glide_web/views/webViewScreen/web_view_screen.dart';

class Routes{
  static const String homeScreen ="/homeScreen";
  static const String webViewScreen ="/webViewScreen";


  static MaterialPageRoute? generateRoute(RouteSettings routeSettings){
    final Map<String,WidgetBuilder> routes = {
      homeScreen : (context) => const HomeScreen(),
      webViewScreen : (context) => const WebViewScreen(),
    };
    final WidgetBuilder? builder = routes[routeSettings.name];
    return (builder != null) ? MaterialPageRoute(builder: builder): null;

  }

}