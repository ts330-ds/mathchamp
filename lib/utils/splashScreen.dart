import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathchamp/routes/paths.dart';
import 'package:mathchamp/services/musicPlayerService.dart';
import 'package:mathchamp/utils/custom_theme.dart';

import '../main.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _logoController;
  late AnimationController _textController;
  late AnimationController _bubbleController;
  late Animation<double> _logoScaleAnimation;
  late Animation<double> _logoRotateAnimation;
  late Animation<double> _textSlideAnimation;
  late Animation<double> _textFadeAnimation;

  final List<FloatingBubble> _bubbles = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    // Logo animation controller
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // Text animation controller
    _textController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // Bubble animation controller
    _bubbleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 10),
    )..repeat();

    // Logo bounce animation
    _logoScaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 0.9)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.9, end: 1.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 20,
      ),
    ]).animate(_logoController);

    // Logo rotate animation
    _logoRotateAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: -0.1, end: 0.1)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.1, end: 0.0)
            .chain(CurveTween(curve: Curves.easeInOut)),
        weight: 50,
      ),
    ]).animate(_logoController);

    // Text slide animation
    _textSlideAnimation = Tween<double>(begin: 50, end: 0).animate(
      CurvedAnimation(parent: _textController, curve: Curves.elasticOut),
    );

    // Text fade animation
    _textFadeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(parent: _textController, curve: Curves.easeIn),
    );

    // Generate floating bubbles
    _generateBubbles();

    // Start animations
    _logoController.forward();
    Future.delayed(const Duration(milliseconds: 800), () {
      _textController.forward();
    });

    // Navigate to HomeScreen after animation
    Timer(const Duration(seconds: 3), () {
      bool isPlayed = prefs.getBool("backgroundMusic") ?? true;
      if (isPlayed) MusicService.play();
      context.go(Paths.homeScreen);
    });
  }

  void _generateBubbles() {
    for (int i = 0; i < 15; i++) {
      _bubbles.add(FloatingBubble(
        x: _random.nextDouble(),
        y: _random.nextDouble(),
        size: _random.nextDouble() * 40 + 20,
        speed: _random.nextDouble() * 0.5 + 0.3,
        color: MathChampTheme.quizCardColors[
            _random.nextInt(MathChampTheme.quizCardColors.length)],
      ));
    }
  }

  @override
  void dispose() {
    _logoController.dispose();
    _textController.dispose();
    _bubbleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: AnimatedBuilder(
        animation: _bubbleController,
        builder: (context, child) {
          return Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xFF6C63FF),
                  Color(0xFF8B5CF6),
                  Color(0xFFEC4899),
                ],
              ),
            ),
            child: Stack(
              children: [
                // Floating bubbles background
                ..._bubbles.map((bubble) {
                  double animatedY =
                      (bubble.y - _bubbleController.value * bubble.speed) % 1.0;
                  return Positioned(
                    left: bubble.x * MediaQuery.of(context).size.width,
                    top: animatedY * MediaQuery.of(context).size.height,
                    child: Container(
                      width: bubble.size,
                      height: bubble.size,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: bubble.color.withOpacity(0.3),
                      ),
                    ),
                  );
                }),
                // Main content
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Animated Logo
                      AnimatedBuilder(
                        animation: _logoController,
                        builder: (context, child) {
                          return Transform.scale(
                            scale: _logoScaleAnimation.value,
                            child: Transform.rotate(
                              angle: _logoRotateAnimation.value,
                              child: Container(
                                padding: EdgeInsets.all(20.w),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(30.w),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 30,
                                      offset: const Offset(0, 15),
                                    ),
                                  ],
                                ),
                                child: Image.asset(
                                  "assets/logo.png",
                                  width: 100.w,
                                  height: 100.w,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                      SizedBox(height: 30.w),
                      // Animated Title
                      AnimatedBuilder(
                        animation: _textController,
                        builder: (context, child) {
                          return Opacity(
                            opacity: _textFadeAnimation.value,
                            child: Transform.translate(
                              offset: Offset(0, _textSlideAnimation.value),
                              child: Column(
                                children: [
                                  Text(
                                    'MathChamp',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 42.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                      shadows: [
                                        Shadow(
                                          color: Colors.black.withOpacity(0.3),
                                          offset: const Offset(2, 2),
                                          blurRadius: 4,
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 8.w),
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20.w, vertical: 8.w),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFFFD93D),
                                      borderRadius: BorderRadius.circular(20.w),
                                    ),
                                    child: Text(
                                      'For Kids 4-16 Years',
                                      style: GoogleFonts.nunito(
                                        fontSize: 16.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF2D3436),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 20.w),
                                  // Fun math symbols
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      _buildMathSymbol('+', Colors.red.shade300),
                                      SizedBox(width: 10.w),
                                      _buildMathSymbol('-', Colors.blue.shade300),
                                      SizedBox(width: 10.w),
                                      _buildMathSymbol('×', Colors.green.shade300),
                                      SizedBox(width: 10.w),
                                      _buildMathSymbol('÷', Colors.orange.shade300),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                // Loading indicator at bottom
                Positioned(
                  bottom: 50.w,
                  left: 0,
                  right: 0,
                  child: Column(
                    children: [
                      SizedBox(
                        width: 30.w,
                        height: 30.w,
                        child: const CircularProgressIndicator(
                          valueColor:
                              AlwaysStoppedAnimation<Color>(Colors.white),
                          strokeWidth: 3,
                        ),
                      ),
                      SizedBox(height: 10.w),
                      Text(
                        'Loading fun...',
                        style: GoogleFonts.nunito(
                          fontSize: 14.sp,
                          color: Colors.white.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildMathSymbol(String symbol, Color color) {
    return Container(
      width: 40.w,
      height: 40.w,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(12.w),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.5),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Center(
        child: Text(
          symbol,
          style: GoogleFonts.fredoka(
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class FloatingBubble {
  final double x;
  final double y;
  final double size;
  final double speed;
  final Color color;

  FloatingBubble({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
  });
}
