import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:go_router/go_router.dart';
import 'package:mathchamp/ads/adsCubit.dart';
import 'package:mathchamp/feature/2Player/player_2_screen.dart';
import 'package:mathchamp/feature/home/commonStartGameScreen.dart';
import 'package:mathchamp/feature/home/homeScreen.dart';
import 'package:mathchamp/feature/questions/questionScreen.dart';
import 'package:mathchamp/feature/setting/childProfile.dart';
import 'package:mathchamp/feature/setting/settingScreen.dart';
import 'package:mathchamp/routes/paths.dart';
import 'package:mathchamp/utils/splashScreen.dart';

import '../ads/navigationObserver.dart';
import '../utils/errorScreen.dart';

class RouterConfiguration {
  static GoRouter router(AdCubit asCubit) {
    return GoRouter(
        observers: [
          AdNavigatorObserver(asCubit),
          FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
        ],
        initialLocation: Paths.splashScreen,
        routes: [
          myroute(Paths.splashScreen, SplashScreen()),
          myroute(Paths.homeScreen, HomeScreen()),
          myroute(Paths.settingScreen, SettingScreen()),
          myroute(Paths.childProfileScreen, ChildProfile()),
          myroute(Paths.commonStartGameScreen, CommonStartGamescreen()),
          myroute(Paths.questionScreen, QuestionScreen()),
          GoRoute(
            path: Paths.player_2_screen,
            builder: (context, state) {
              final extra = state.extra as Map<String, String>? ?? {};
              return Player2Screen(
                player1Name: extra['player1'] ?? 'Player 1',
                player2Name: extra['player2'] ?? 'Player 2',
              );
            },
          ),
        ],
        errorBuilder: (context, state) {
          return const ErrorScreen();
        });
  }

  static GoRoute myroute(String path, Widget widget) {
    return GoRoute(
        path: path,
        builder: (context, state) {
          return widget;
        });
  }
}
