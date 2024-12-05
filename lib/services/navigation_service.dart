import 'package:flutter/material.dart';

class NavigationService{
    static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

    void removeAndNavigateToRoute(String route){
      navigatorKey.currentState?.popAndPushNamed(route);
    }

    void navigateToRoute(String route){
      navigatorKey.currentState?.pushNamed(route);
    }

    void navigateToScreen(Widget screen){
      navigatorKey.currentState?.push(
        MaterialPageRoute(builder: (ctx) => screen)
      );
    }

    void goBack(){
      navigatorKey.currentState?.pop();
    }
}