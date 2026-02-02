import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathchamp/utils/custom_theme.dart';

void showCongratsDialog(
    BuildContext context,
    String userName,
    int time,
    int firstDigit,
    int lastDigit,
    String gameName) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return _CongratsDialog(
        userName: userName,
        time: time,
        firstDigit: firstDigit,
        lastDigit: lastDigit,
        gameName: gameName,
        parentContext: context,
      );
    },
  );
}

class _CongratsDialog extends StatefulWidget {
  final String userName;
  final int time;
  final int firstDigit;
  final int lastDigit;
  final String gameName;
  final BuildContext parentContext;

  const _CongratsDialog({
    required this.userName,
    required this.time,
    required this.firstDigit,
    required this.lastDigit,
    required this.gameName,
    required this.parentContext,
  });

  @override
  State<_CongratsDialog> createState() => _CongratsDialogState();
}

class _CongratsDialogState extends State<_CongratsDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _confettiController;
  late Animation<double> _scaleAnimation;
  final List<_Confetti> _confettiList = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _confettiController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _scaleAnimation = TweenSequence<double>([
      TweenSequenceItem(
        tween: Tween<double>(begin: 0.0, end: 1.2)
            .chain(CurveTween(curve: Curves.easeOut)),
        weight: 60,
      ),
      TweenSequenceItem(
        tween: Tween<double>(begin: 1.2, end: 1.0)
            .chain(CurveTween(curve: Curves.elasticOut)),
        weight: 40,
      ),
    ]).animate(_scaleController);

    // Generate confetti
    for (int i = 0; i < 50; i++) {
      _confettiList.add(_Confetti(
        x: _random.nextDouble(),
        y: _random.nextDouble() - 1,
        size: _random.nextDouble() * 12 + 6,
        speed: _random.nextDouble() * 0.5 + 0.3,
        color: MathChampTheme.quizCardColors[
            _random.nextInt(MathChampTheme.quizCardColors.length)],
        rotation: _random.nextDouble() * 360,
      ));
    }

    _scaleController.forward();
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _confettiController.dispose();
    super.dispose();
  }

  String _getPerformanceEmoji() {
    if (widget.time < 30) return '🚀';
    if (widget.time < 60) return '⚡';
    if (widget.time < 120) return '🌟';
    return '👍';
  }

  String _getPerformanceMessage() {
    if (widget.time < 30) return 'Super Fast!';
    if (widget.time < 60) return 'Amazing Speed!';
    if (widget.time < 120) return 'Great Job!';
    return 'Well Done!';
  }

  int _getStars() {
    if (widget.time < 30) return 3;
    if (widget.time < 60) return 3;
    if (widget.time < 120) return 2;
    return 1;
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        Navigator.of(context).pop(true);
        widget.parentContext.pop();
      },
      child: AnimatedBuilder(
        animation: _confettiController,
        builder: (context, child) {
          return Dialog(
            backgroundColor: Colors.transparent,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Confetti
                ..._confettiList.map((confetti) {
                  double animatedY =
                      (confetti.y + _confettiController.value * confetti.speed * 2) % 2 - 0.5;
                  return Positioned(
                    left: confetti.x * 300.w,
                    top: animatedY * 500.w,
                    child: Transform.rotate(
                      angle: confetti.rotation +
                          _confettiController.value * 6.28,
                      child: Container(
                        width: confetti.size,
                        height: confetti.size,
                        decoration: BoxDecoration(
                          color: confetti.color,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  );
                }),
                // Main dialog
                AnimatedBuilder(
                  animation: _scaleAnimation,
                  builder: (context, child) {
                    return Transform.scale(
                      scale: _scaleAnimation.value,
                      child: Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(32.w),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF6C63FF).withOpacity(0.3),
                              blurRadius: 30,
                              offset: const Offset(0, 15),
                            ),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Trophy/Celebration
                            Container(
                              width: 100.w,
                              height: 100.w,
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [Color(0xFFFFD93D), Color(0xFFFFA726)],
                                ),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFFFFD93D).withOpacity(0.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 10),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  '🏆',
                                  style: TextStyle(fontSize: 50.sp),
                                ),
                              ),
                            ),
                            SizedBox(height: 16.w),
                            // Stars
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: List.generate(3, (index) {
                                bool isEarned = index < _getStars();
                                return Padding(
                                  padding: EdgeInsets.symmetric(horizontal: 4.w),
                                  child: Text(
                                    isEarned ? '⭐' : '☆',
                                    style: TextStyle(
                                      fontSize: 32.sp,
                                      color: isEarned
                                          ? null
                                          : const Color(0xFFDDDDDD),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            SizedBox(height: 16.w),
                            // Congratulations text
                            Text(
                              'Congratulations!',
                              style: GoogleFonts.fredoka(
                                fontSize: 28.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF6C63FF),
                              ),
                            ),
                            SizedBox(height: 8.w),
                            // User name
                            Text(
                              widget.userName,
                              style: GoogleFonts.fredoka(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2D3436),
                              ),
                            ),
                            SizedBox(height: 16.w),
                            // Stats card
                            Container(
                              padding: EdgeInsets.all(16.w),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF8F9FA),
                                borderRadius: BorderRadius.circular(20.w),
                              ),
                              child: Column(
                                children: [
                                  // Game info
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        getGameSign(widget.gameName),
                                        style: GoogleFonts.fredoka(
                                          fontSize: 24.sp,
                                          color: const Color(0xFF6C63FF),
                                        ),
                                      ),
                                      SizedBox(width: 8.w),
                                      Text(
                                        widget.gameName,
                                        style: GoogleFonts.fredoka(
                                          fontSize: 18.sp,
                                          fontWeight: FontWeight.bold,
                                          color: const Color(0xFF2D3436),
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8.w),
                                  // Difficulty
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 12.w, vertical: 4.w),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF6BCB77).withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12.w),
                                    ),
                                    child: Text(
                                      '${widget.firstDigit} × ${widget.lastDigit} Digits',
                                      style: GoogleFonts.nunito(
                                        fontSize: 14.sp,
                                        fontWeight: FontWeight.bold,
                                        color: const Color(0xFF6BCB77),
                                      ),
                                    ),
                                  ),
                                  SizedBox(height: 12.w),
                                  // Time
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        _getPerformanceEmoji(),
                                        style: TextStyle(fontSize: 24.sp),
                                      ),
                                      SizedBox(width: 8.w),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            _getPerformanceMessage(),
                                            style: GoogleFonts.fredoka(
                                              fontSize: 16.sp,
                                              fontWeight: FontWeight.bold,
                                              color: const Color(0xFF2D3436),
                                            ),
                                          ),
                                          Text(
                                            '${widget.time} seconds',
                                            style: GoogleFonts.nunito(
                                              fontSize: 14.sp,
                                              color: const Color(0xFF636E72),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 16.w),
                            // Share message
                            Text(
                              'Share your achievement!',
                              style: GoogleFonts.nunito(
                                fontSize: 14.sp,
                                color: const Color(0xFF636E72),
                              ),
                            ),
                            SizedBox(height: 8.w),
                            // Logo
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  "assets/logo.png",
                                  width: 40.w,
                                  height: 40.w,
                                  fit: BoxFit.contain,
                                ),
                                SizedBox(width: 8.w),
                                Text(
                                  'MathChamp',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 16.sp,
                                    color: const Color(0xFF6C63FF),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20.w),
                            // Close button
                            GestureDetector(
                              onTap: () {
                                Navigator.of(context).pop(true);
                                widget.parentContext.pop();
                              },
                              child: Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(vertical: 16.w),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
                                  ),
                                  borderRadius: BorderRadius.circular(20.w),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF6C63FF).withOpacity(0.4),
                                      blurRadius: 15,
                                      offset: const Offset(0, 8),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    'Awesome! 🎉',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 18.sp,
                                      fontWeight: FontWeight.bold,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

class _Confetti {
  final double x;
  final double y;
  final double size;
  final double speed;
  final Color color;
  final double rotation;

  _Confetti({
    required this.x,
    required this.y,
    required this.size,
    required this.speed,
    required this.color,
    required this.rotation,
  });
}

String getGameSign(String gameName) {
  switch (gameName) {
    case "Addition":
      return "+";
    case "Subtraction":
      return "-";
    case "Multiplication":
      return "×";
    case "Division":
      return "÷";
    case "Mixed":
      return "+ - × ÷";
    case "Power":
    case "Powers":
      return "^";
    case "Root":
    case "Square Root":
      return "√";
    case "Multiplication Tables":
      return "×";
    default:
      return "🔢";
  }
}
