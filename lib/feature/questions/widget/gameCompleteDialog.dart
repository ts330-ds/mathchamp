import 'dart:math';
import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathchamp/utils/custom_theme.dart';
import 'package:share_plus/share_plus.dart';

void showCongratsDialog(
    BuildContext context,
    String userName,
    int time,
    int firstDigit,
    int lastDigit,
    String gameName,
    int correctCount,
    int wrongCount,
    int totalQuestions) {
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
        correctCount: correctCount,
        wrongCount: wrongCount,
        totalQuestions: totalQuestions,
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
  final int correctCount;
  final int wrongCount;
  final int totalQuestions;

  const _CongratsDialog({
    required this.userName,
    required this.time,
    required this.firstDigit,
    required this.lastDigit,
    required this.gameName,
    required this.parentContext,
    required this.correctCount,
    required this.wrongCount,
    required this.totalQuestions,
  });

  @override
  State<_CongratsDialog> createState() => _CongratsDialogState();
}

class _CongratsDialogState extends State<_CongratsDialog>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _confettiController;
  late AnimationController _scoreBarController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _scoreBarAnimation;
  final List<_Confetti> _confettiList = [];
  final Random _random = Random();
  bool _isSharing = false;

  // Key to capture only the result card (not confetti/dialog chrome)
  final GlobalKey _shareCardKey = GlobalKey();

  // Key on the share button — needed for iPad popover anchor
  final GlobalKey _shareButtonKey = GlobalKey();

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

    _scoreBarController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

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

    _scoreBarAnimation = CurvedAnimation(
      parent: _scoreBarController,
      curve: Curves.easeOutCubic,
    );

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
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _scoreBarController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _confettiController.dispose();
    _scoreBarController.dispose();
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
    if (widget.totalQuestions == 0) return 1;
    final pct = widget.correctCount / widget.totalQuestions;
    if (pct == 1.0) return 3;
    if (pct >= 0.6) return 2;
    return 1;
  }

  double get _accuracy => widget.totalQuestions == 0
      ? 0
      : widget.correctCount / widget.totalQuestions;

  // ── Capture the share card and open share sheet ──
  Future<void> _shareResult() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);

    try {
      // Stop confetti briefly so the static screenshot looks clean
      _confettiController.stop();

      await Future.delayed(const Duration(milliseconds: 80));

      final RenderRepaintBoundary boundary = _shareCardKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      final accuracy = (_accuracy * 100).toStringAsFixed(0);
      const playStoreLink =
          'https://play.google.com/store/apps/details?id=com.tsanalysis.mathchamp';
      final shareText =
          '🏆 I scored $accuracy% in ${widget.gameName} on MathChamp!\n'
          '✅ ${widget.correctCount} correct | ❌ ${widget.wrongCount} wrong | ⏱ ${widget.time}s\n'
          '🎮 Download MathChamp and beat my score!\n'
          '$playStoreLink';

      // Get the share button's position for iPad popover anchor
      final box = _shareButtonKey.currentContext?.findRenderObject() as RenderBox?;
      final origin = box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : const Rect.fromLTWH(0, 0, 100, 100);

      await Share.shareXFiles(
        [
          XFile.fromData(
            pngBytes,
            name: 'mathchamp_result.png',
            mimeType: 'image/png',
          ),
        ],
        text: shareText,
        sharePositionOrigin: origin,
      );
    } catch (e) {
      debugPrint('Share failed: $e');
    } finally {
      if (mounted) {
        _confettiController.repeat();
        setState(() => _isSharing = false);
      }
    }
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
            insetPadding:
                EdgeInsets.symmetric(horizontal: 16.w, vertical: 24.w),
          child: Stack(
              clipBehavior: Clip.none,
              children: [
                // Confetti
                ..._confettiList.map((confetti) {
                  double animatedY =
                      (confetti.y + _confettiController.value * confetti.speed * 2) %
                          2 -
                          0.5;
                  return Positioned(
                    left: confetti.x * 300.w,
                    top: animatedY * 500.w,
                    child: Transform.rotate(
                      angle: confetti.rotation + _confettiController.value * 6.28,
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
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              // ── Share card (captured as screenshot) ──
                              RepaintBoundary(
                                key: _shareCardKey,
                                child: _ShareCard(
                                  userName: widget.userName,
                                  gameName: widget.gameName,
                                  firstDigit: widget.firstDigit,
                                  lastDigit: widget.lastDigit,
                                  correctCount: widget.correctCount,
                                  wrongCount: widget.wrongCount,
                                  totalQuestions: widget.totalQuestions,
                                  time: widget.time,
                                  stars: _getStars(),
                                  accuracy: _accuracy,
                                  scoreBarAnimation: _scoreBarAnimation,
                                  performanceEmoji: _getPerformanceEmoji(),
                                  performanceMessage: _getPerformanceMessage(),
                                ),
                              ),

                              // ── Buttons row ──
                              Padding(
                                padding: EdgeInsets.fromLTRB(24.w, 0, 24.w, 24.w),
                                child: Row(
                                  children: [
                                    // Share button
                                    Expanded(
                                      child: GestureDetector(
                                        key: _shareButtonKey,
                                        onTap: _isSharing ? null : _shareResult,
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 200),
                                          padding: EdgeInsets.symmetric(vertical: 16.w),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF6BCB77),
                                                Color(0xFF4ECDC4),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(20.w),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF6BCB77)
                                                    .withOpacity(0.4),
                                                blurRadius: 12,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: _isSharing
                                                ? SizedBox(
                                                    width: 22.w,
                                                    height: 22.w,
                                                    child: const CircularProgressIndicator(
                                                      color: Colors.white,
                                                      strokeWidth: 2.5,
                                                    ),
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment.center,
                                                    children: [
                                                      Icon(
                                                        Icons.share_rounded,
                                                        color: Colors.white,
                                                        size: 20.w,
                                                      ),
                                                      SizedBox(width: 6.w),
                                                      Text(
                                                        'Share',
                                                        style: GoogleFonts.fredoka(
                                                          fontSize: 17.sp,
                                                          fontWeight: FontWeight.bold,
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 12.w),
                                    // Done button
                                    Expanded(
                                      child: GestureDetector(
                                        onTap: () {
                                          Navigator.of(context).pop(true);
                                          widget.parentContext.pop();
                                        },
                                        child: Container(
                                          padding:
                                              EdgeInsets.symmetric(vertical: 16.w),
                                          decoration: BoxDecoration(
                                            gradient: const LinearGradient(
                                              colors: [
                                                Color(0xFF6C63FF),
                                                Color(0xFF8B5CF6),
                                              ],
                                            ),
                                            borderRadius: BorderRadius.circular(20.w),
                                            boxShadow: [
                                              BoxShadow(
                                                color: const Color(0xFF6C63FF)
                                                    .withOpacity(0.4),
                                                blurRadius: 12,
                                                offset: const Offset(0, 6),
                                              ),
                                            ],
                                          ),
                                          child: Center(
                                            child: Text(
                                              'Awesome! 🎉',
                                              style: GoogleFonts.fredoka(
                                                fontSize: 17.sp,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.white,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
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

// ── The shareable card widget (also shown inside the dialog) ──
class _ShareCard extends StatelessWidget {
  final String userName;
  final String gameName;
  final int firstDigit;
  final int lastDigit;
  final int correctCount;
  final int wrongCount;
  final int totalQuestions;
  final int time;
  final int stars;
  final double accuracy;
  final Animation<double> scoreBarAnimation;
  final String performanceEmoji;
  final String performanceMessage;

  const _ShareCard({
    required this.userName,
    required this.gameName,
    required this.firstDigit,
    required this.lastDigit,
    required this.correctCount,
    required this.wrongCount,
    required this.totalQuestions,
    required this.time,
    required this.stars,
    required this.accuracy,
    required this.scoreBarAnimation,
    required this.performanceEmoji,
    required this.performanceMessage,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      padding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, 16.w),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Trophy
          Container(
            width: 90.w,
            height: 90.w,
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
              child: Text('🏆', style: TextStyle(fontSize: 44.sp)),
            ),
          ),
          SizedBox(height: 12.w),

          // Stars
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(3, (index) {
              bool isEarned = index < stars;
              return Padding(
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                child: Text(
                  isEarned ? '⭐' : '☆',
                  style: TextStyle(
                    fontSize: 30.sp,
                    color: isEarned ? null : const Color(0xFFDDDDDD),
                  ),
                ),
              );
            }),
          ),
          SizedBox(height: 10.w),

          // Congrats + name
          Text(
            'Congratulations!',
            style: GoogleFonts.fredoka(
              fontSize: 26.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF6C63FF),
            ),
          ),
          Text(
            userName,
            style: GoogleFonts.fredoka(
              fontSize: 20.sp,
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
                // Game name + digits
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      getGameSign(gameName),
                      style: GoogleFonts.fredoka(
                        fontSize: 22.sp,
                        color: const Color(0xFF6C63FF),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Text(
                      gameName,
                      style: GoogleFonts.fredoka(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D3436),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 10.w, vertical: 3.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFF6BCB77).withOpacity(0.2),
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      child: Text(
                        '${firstDigit}×${lastDigit} Digits',
                        style: GoogleFonts.nunito(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF6BCB77),
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.w),

                // Correct / Wrong / Total
                Row(
                  children: [
                    Expanded(
                      child: _StatBox(
                        emoji: '✅',
                        label: 'Correct',
                        value: '$correctCount',
                        color: const Color(0xFF6BCB77),
                        bgColor: const Color(0xFFE8F8ED),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _StatBox(
                        emoji: '❌',
                        label: 'Wrong',
                        value: '$wrongCount',
                        color: const Color(0xFFFF6B6B),
                        bgColor: const Color(0xFFFFEEEE),
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Expanded(
                      child: _StatBox(
                        emoji: '📝',
                        label: 'Total',
                        value: '$totalQuestions',
                        color: const Color(0xFF6C63FF),
                        bgColor: const Color(0xFFEEEDFF),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.w),

                // Accuracy bar
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Accuracy',
                          style: GoogleFonts.nunito(
                            fontSize: 13.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF636E72),
                          ),
                        ),
                        Text(
                          '${(accuracy * 100).toStringAsFixed(0)}%',
                          style: GoogleFonts.fredoka(
                            fontSize: 14.sp,
                            fontWeight: FontWeight.bold,
                            color: accuracy >= 0.6
                                ? const Color(0xFF6BCB77)
                                : const Color(0xFFFF6B6B),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 6.w),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(8.w),
                      child: AnimatedBuilder(
                        animation: scoreBarAnimation,
                        builder: (context, _) {
                          return LinearProgressIndicator(
                            value: accuracy * scoreBarAnimation.value,
                            minHeight: 10.w,
                            backgroundColor: const Color(0xFFE0E0E0),
                            valueColor: AlwaysStoppedAnimation<Color>(
                              accuracy >= 0.6
                                  ? const Color(0xFF6BCB77)
                                  : const Color(0xFFFF6B6B),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 14.w),

                // Time row
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(performanceEmoji,
                        style: TextStyle(fontSize: 22.sp)),
                    SizedBox(width: 8.w),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          performanceMessage,
                          style: GoogleFonts.fredoka(
                            fontSize: 15.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF2D3436),
                          ),
                        ),
                        Text(
                          '$time seconds',
                          style: GoogleFonts.nunito(
                            fontSize: 13.sp,
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
          SizedBox(height: 14.w),

          // MathChamp branding (always visible in screenshot)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/logo.png',
                width: 28.w,
                height: 28.w,
                fit: BoxFit.contain,
              ),
              SizedBox(width: 6.w),
              Text(
                'MathChamp',
                style: GoogleFonts.fredoka(
                  fontSize: 14.sp,
                  color: const Color(0xFF6C63FF),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.w),
        ],
      ),
    );
  }
}

// ── Small stat box ──
class _StatBox extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color color;
  final Color bgColor;

  const _StatBox({
    required this.emoji,
    required this.label,
    required this.value,
    required this.color,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 12.w),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(16.w),
      ),
      child: Column(
        children: [
          Text(emoji, style: TextStyle(fontSize: 22.sp)),
          SizedBox(height: 4.w),
          Text(
            value,
            style: GoogleFonts.fredoka(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            label,
            style: GoogleFonts.nunito(
              fontSize: 11.sp,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

// ── Confetti particle ──
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
