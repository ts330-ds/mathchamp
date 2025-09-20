// lib/screens/splash_screen.dart
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:mathchamp/customPainter/backgorund_painter.dart';
import 'package:mathchamp/routes/paths.dart';
import 'package:mathchamp/services/musicPlayerService.dart';

import '../feature/home/homeScreen.dart';
import '../main.dart';
// next screen

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  double _opacity = 0.0;

  @override
  void initState() {
    super.initState();

    // Start fade-in animation
    Timer(const Duration(milliseconds: 1500), () {
      setState(() {
        _opacity = 1.0;
      });
    });

    // Navigate to HomeScreen after animation ends (3 seconds)
    Timer(const Duration(seconds: 3), () {
      bool isplayed = prefs.getBool("backgroundMusic") ?? true;
      if(isplayed) MusicService.play();
      context.go(Paths.homeScreen);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedOpacity(
        opacity: _opacity,
        duration: const Duration(seconds: 2),
        curve: Curves.easeInOut,
        child: Container(
          color: Colors.blue.shade800,
          alignment: Alignment.center,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                "assets/logo.png",
                width: 100,
                height: 100,
                fit: BoxFit.contain
              ),
              const SizedBox(height: 20),
              const Text(
                'MathChamp',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
