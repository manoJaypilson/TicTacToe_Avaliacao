import 'package:flutter/material.dart';
import 'package:custom_splash/custom_splash.dart';
import 'package:tictactoe/core/constants.dart';
import 'package:tictactoe/core/theme_app.dart';
import 'pages/game_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        debugShowCheckedModeBanner: false,
        title: GAME_TITLE,
        theme: themeApp,
        home: CustomSplash(
          imagePath: 'assets/images/icon.png',
          backGroundColor: Colors.deepOrange,
          animationEffect: 'zoom-in',
          logoSize: 200,
          home: GamePage(),
          duration: 2500,
          type: CustomSplashType.StaticDuration,
        ));
  }
}
