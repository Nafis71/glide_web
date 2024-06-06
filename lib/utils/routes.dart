import 'package:flutter/material.dart';
import 'package:glide_web/views/homeScreen/home_screen.dart';
import 'package:glide_web/views/webViewScreen/web_view_screen.dart';
import 'package:page_transition/page_transition.dart';

class Routes{
  static const String homeScreen ="/homeScreen";
  static const String webViewScreen ="/webViewScreen";


  static PageTransition? generateRoute(RouteSettings routeSettings){
    final Map<String,PageTransition> routes = {
      homeScreen : PageTransition(
    type: PageTransitionType.rightToLeft,
    child: const HomeScreen(),
    isIos: true,
    ),
      webViewScreen : PageTransition(
    type: PageTransitionType.rightToLeft,
    child: const WebViewScreen(),
    isIos: true,
    ),
    };
    final PageTransition? pageTransition = routes[routeSettings.name];
    return (pageTransition !=null) ? pageTransition : null;

  }

}