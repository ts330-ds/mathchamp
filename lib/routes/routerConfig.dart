import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mathchamp/feature/home/homeScreen.dart';
import 'package:mathchamp/feature/setting/childProfile.dart';
import 'package:mathchamp/feature/setting/settingScreen.dart';
import 'package:mathchamp/routes/paths.dart';
import 'package:mathchamp/utils/splashScreen.dart';

import '../utils/errorScreen.dart';

class RouterConfiguration {
  static GoRouter router = GoRouter(
      initialLocation: Paths.splashScreen,
      routes: [
        myroute(Paths.splashScreen, SplashScreen()),
        myroute(Paths.homeScreen, HomeScreen()),
        myroute(Paths.settingScreen, SettingScreen()),
        myroute(Paths.childProfileScreen, ChildProfile())
      ],
      errorBuilder: (context, state) {
        return const ErrorScreen();
      });

  static GoRoute myroute(String path, Widget widget) {
    return GoRoute(
        path: path,
        builder: (context, state) {
          return widget;
        });
  }
}
