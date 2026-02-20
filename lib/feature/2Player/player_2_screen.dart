import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathchamp/ads/adsCubit.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailCubit.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailState.dart';
import 'package:mathchamp/feature/questions/cubit/questionCubit.dart';
import 'package:mathchamp/feature/questions/cubit/questionState.dart';
import 'package:mathchamp/feature/questions/model/questionModel.dart';
import 'package:mathchamp/utils/custom_theme.dart';
import 'package:mathchamp/services/analyticsService.dart';
import 'package:share_plus/share_plus.dart';

class Player2Screen extends StatefulWidget {
  final String player1Name;
  final String player2Name;

  const Player2Screen({
    super.key,
    required this.player1Name,
    required this.player2Name,
  });

  @override
  State<Player2Screen> createState() => _Player2ScreenState();
}

class _Player2ScreenState extends State<Player2Screen>
    with TickerProviderStateMixin {
  // Per-player scores (independent of cubit which tracks single-player)
  int _p1Correct = 0;
  int _p1Wrong = 0;
  int _p2Correct = 0;
  int _p2Wrong = 0;

  // Which player has answered current question (-1 = none, 0 = p1, 1 = p2)
  int? _p1Answer; // option value chosen by p1
  int? _p2Answer; // option value chosen by p2

  // Whether result dialog already shown for this game
  bool _resultShown = false;

  late AnimationController _p1ScaleCtrl;
  late AnimationController _p2ScaleCtrl;

  @override
  void initState() {
    super.initState();
    AnalyticsService.instance.logScreen('player_2_screen');
    _p1ScaleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
    _p2ScaleCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300));
  }

  @override
  void dispose() {
    _p1ScaleCtrl.dispose();
    _p2ScaleCtrl.dispose();
    super.dispose();
  }

  void _onPlayerTap(bool isPlayer1, int option, Question question,
      QuestionsCubit cubit, QuestionState state) {
    // Ignore if this player already answered
    if (isPlayer1 && _p1Answer != null) return;
    if (!isPlayer1 && _p2Answer != null) return;

    final isCorrect = option == question.correctAnswer;

    setState(() {
      if (isPlayer1) {
        _p1Answer = option;
        if (isCorrect)
          _p1Correct++;
        else
          _p1Wrong++;
        _p1ScaleCtrl.forward().then((_) => _p1ScaleCtrl.reverse());
      } else {
        _p2Answer = option;
        if (isCorrect)
          _p2Correct++;
        else
          _p2Wrong++;
        _p2ScaleCtrl.forward().then((_) => _p2ScaleCtrl.reverse());
      }
    });

    // Both answered → advance after short delay
    if (_p1Answer != null && _p2Answer != null) {
      Future.delayed(const Duration(milliseconds: 800), () {
        if (!mounted) return;
        setState(() {
          _p1Answer = null;
          _p2Answer = null;
        });
        cubit.nextQuestion();
      });
    }
  }

  void _showResultDialog(
      BuildContext context, QuestionState state, GameDetailState gameState) {
    if (_resultShown) return;
    _resultShown = true;

    // Determine winner for analytics
    String winner;
    if (_p1Correct > _p2Correct) {
      winner = widget.player1Name;
    } else if (_p2Correct > _p1Correct) {
      winner = widget.player2Name;
    } else {
      winner = 'tie';
    }
    AnalyticsService.instance.logTwoPlayerGameCompleted(
      player1Name: widget.player1Name,
      player2Name: widget.player2Name,
      p1Correct: _p1Correct,
      p2Correct: _p2Correct,
      totalQuestions: state.questions.length,
      timeTakenSeconds: state.totalTimeTaken?.inSeconds ?? 0,
      winner: winner,
    );

    final adCubit = context.read<AdCubit>();

    void openDialog() {
      if (!context.mounted) return;
      showTwoPlayerResultDialog(
        context: context,
        player1Name: widget.player1Name,
        player2Name: widget.player2Name,
        p1Correct: _p1Correct,
        p1Wrong: _p1Wrong,
        p2Correct: _p2Correct,
        p2Wrong: _p2Wrong,
        totalQuestions: state.questions.length,
        timeTaken: state.totalTimeTaken?.inSeconds ?? 0,
      );
    }

    if (adCubit.state.result_Interstial != null) {
      adCubit.showResultInterstitial();
      WidgetsBinding.instance.addPostFrameCallback((_) => openDialog());
    } else {
      openDialog();
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text('Quit Game?',
                style: Theme.of(context).textTheme.labelMedium),
            content: const Text('Are you sure you want to quit?'),
            actions: [
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: const Text('No')),
              TextButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: const Text('Yes')),
            ],
          ),
        );
        if (!context.mounted) return;
        if (shouldExit == true) context.pop();
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1A1A2E),
        body: SafeArea(
          child: BlocBuilder<GameDetailCubit, GameDetailState>(
            builder: (context, gameState) {
              return BlocConsumer<QuestionsCubit, QuestionState>(
                listener: (context, state) {
                  if (state.gameCompleted == true) {
                    _showResultDialog(context, state, gameState);
                  }
                },
                builder: (context, state) {
                  final cubit = context.read<QuestionsCubit>();

                  if (state.questions.isEmpty || state.isLoading) {
                    return const Center(
                        child: CircularProgressIndicator(color: Colors.white));
                  }

                  final question = state.questions[state.currentIndex];
                  final total = state.questions.length;
                  final current = state.currentIndex + 1;

                  return Column(
                    children: [
                      // ── Player 2 (top half — rotated 180° so P2 faces up) ──
                      Expanded(
                        child: RotatedBox(
                          quarterTurns: 2,
                          child: _PlayerPanel(
                            playerName: widget.player2Name,
                            playerColor: const Color(0xFFFF6B6B),
                            playerEmoji: '🔴',
                            correct: _p2Correct,
                            wrong: _p2Wrong,
                            question: question,
                            selectedAnswer: _p2Answer,
                            otherAnswered: _p1Answer != null,
                            isRotated: true,
                            onTap: (option) => _onPlayerTap(
                                false, option, question, cubit, state),
                          ),
                        ),
                      ),

                      // ── Centre bar (progress + score + quit) ──
                      _buildTopBar(context, current, total, state),

                      // ── Player 1 (bottom half — normal orientation) ──
                      Expanded(
                        child: _PlayerPanel(
                          playerName: widget.player1Name,
                          playerColor: const Color(0xFF6C63FF),
                          playerEmoji: '🔵',
                          correct: _p1Correct,
                          wrong: _p1Wrong,
                          question: question,
                          selectedAnswer: _p1Answer,
                          otherAnswered: _p2Answer != null,
                          isRotated: false,
                          onTap: (option) => _onPlayerTap(
                              true, option, question, cubit, state),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(
      BuildContext context, int current, int total, QuestionState state) {
    return Container(
      decoration: const BoxDecoration(
        color: Color(0xFF16213E),
        boxShadow: [
          BoxShadow(color: Colors.black38, blurRadius: 10, spreadRadius: 1),
        ],
      ),
      padding: EdgeInsets.symmetric(horizontal: 14.w, vertical: 8.w),
      child: Row(
        children: [
          // Quit button
          GestureDetector(
            onTap: () async {
              final shouldExit = await showDialog<bool>(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text('Quit Game?',
                      style: Theme.of(context).textTheme.labelMedium),
                  content: const Text('Are you sure?'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.of(ctx).pop(false),
                        child: const Text('No')),
                    TextButton(
                        onPressed: () => Navigator.of(ctx).pop(true),
                        child: const Text('Yes')),
                  ],
                ),
              );
              if (!context.mounted) return;
              if (shouldExit == true) context.pop();
            },
            child: Container(
              padding: EdgeInsets.all(7.w),
              decoration: BoxDecoration(
                color: Colors.white12,
                borderRadius: BorderRadius.circular(10.w),
              ),
              child:
                  Icon(Icons.close_rounded, color: Colors.white70, size: 18.w),
            ),
          ),
          SizedBox(width: 10.w),

          // P2 score (shown on left — P2 is at top of screen)
          _MiniScore(
              color: const Color(0xFFFF6B6B), score: _p2Correct, emoji: '🔴'),

          // Progress bar + question counter in centre
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  '$current / $total',
                  style: GoogleFonts.fredoka(
                      fontSize: 13.sp, color: Colors.white70),
                ),
                SizedBox(height: 3.w),
                ClipRRect(
                  borderRadius: BorderRadius.circular(4.w),
                  child: LinearProgressIndicator(
                    value: current / total,
                    minHeight: 5.w,
                    backgroundColor: Colors.white12,
                    valueColor: const AlwaysStoppedAnimation(Color(0xFFFFD93D)),
                  ),
                ),
              ],
            ),
          ),

          // P1 score (shown on right — P1 is at bottom of screen)
          _MiniScore(
              color: const Color(0xFF6C63FF), score: _p1Correct, emoji: '🔵'),

          SizedBox(width: 10.w),
          // VS badge
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
            decoration: BoxDecoration(
              color: Colors.white10,
              borderRadius: BorderRadius.circular(10.w),
            ),
            child: Text('VS',
                style: GoogleFonts.fredoka(
                    fontSize: 12.sp,
                    color: Colors.white54,
                    fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }
}

// ── Single player panel ──
class _PlayerPanel extends StatelessWidget {
  final String playerName;
  final Color playerColor;
  final String playerEmoji;
  final int correct;
  final int wrong;
  final Question question;
  final int? selectedAnswer;
  final bool otherAnswered;
  final bool isRotated;
  final void Function(int option) onTap;

  const _PlayerPanel({
    required this.playerName,
    required this.playerColor,
    required this.playerEmoji,
    required this.correct,
    required this.wrong,
    required this.question,
    required this.selectedAnswer,
    required this.otherAnswered,
    required this.isRotated,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final answered = selectedAnswer != null;

    return Container(
      color: const Color(0xFF1A1A2E),
      child: Column(
        children: [
          // Player header
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.w),
            color: playerColor.withOpacity(0.15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(playerEmoji, style: TextStyle(fontSize: 16.sp)),
                    SizedBox(width: 6.w),
                    Text(
                      playerName,
                      style: GoogleFonts.fredoka(
                        fontSize: 14.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
                Row(
                  children: [
                    Text('✅$correct',
                        style: GoogleFonts.fredoka(
                            fontSize: 13.sp,
                            color: MathChampTheme.correctAnswer)),
                    SizedBox(width: 6.w),
                    Text('❌$wrong',
                        style: GoogleFonts.fredoka(
                            fontSize: 13.sp,
                            color: MathChampTheme.wrongAnswer)),
                  ],
                ),
              ],
            ),
          ),

          // Question
          Expanded(
            child: LayoutBuilder(
              builder: (context, constraints) {
                // Dynamically scale content to always fit the available height
                final availH = constraints.maxHeight;
                final questionFontSize = (availH * 0.09).clamp(14.0, 22.0);
                final optionFontSize = (availH * 0.07).clamp(12.0, 18.0);
                final statusFontSize = (availH * 0.055).clamp(10.0, 14.0);
                final vPad = (availH * 0.04).clamp(4.0, 12.0);
                final gap = (availH * 0.03).clamp(2.0, 10.0);
                // Grid cell height: divide remaining space sensibly
                final gridItemH = ((availH -
                            questionFontSize * 3 -
                            vPad * 4 -
                            gap * 3 -
                            statusFontSize * 2) /
                        2)
                    .clamp(28.0, 56.0);

                return Padding(
                  padding:
                      EdgeInsets.symmetric(horizontal: 10.w, vertical: vPad),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Question text
                      Container(
                        width: double.infinity,
                        padding: EdgeInsets.symmetric(
                            vertical: vPad * 0.8, horizontal: 10.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.07),
                          borderRadius: BorderRadius.circular(16.w),
                          border:
                              Border.all(color: playerColor.withOpacity(0.4)),
                        ),
                        child: Text(
                          question.questionText,
                          textAlign: TextAlign.center,
                          style: GoogleFonts.fredoka(
                            fontSize: questionFontSize.sp,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      SizedBox(height: gap),

                      // Answered / waiting indicator
                      if (answered)
                        Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 12.w, vertical: gap * 0.5),
                          decoration: BoxDecoration(
                            color: selectedAnswer == question.correctAnswer
                                ? MathChampTheme.correctAnswer.withOpacity(0.2)
                                : MathChampTheme.wrongAnswer.withOpacity(0.2),
                            borderRadius: BorderRadius.circular(10.w),
                            border: Border.all(
                              color: selectedAnswer == question.correctAnswer
                                  ? MathChampTheme.correctAnswer
                                  : MathChampTheme.wrongAnswer,
                            ),
                          ),
                          child: Text(
                            selectedAnswer == question.correctAnswer
                                ? '✅ Correct!'
                                : '❌ Wrong!',
                            style: GoogleFonts.fredoka(
                              fontSize: statusFontSize.sp,
                              color: selectedAnswer == question.correctAnswer
                                  ? MathChampTheme.correctAnswer
                                  : MathChampTheme.wrongAnswer,
                            ),
                          ),
                        )
                      else
                        Text(
                          otherAnswered ? '⏳ Waiting...' : 'Tap your answer!',
                          style: GoogleFonts.nunito(
                            fontSize: statusFontSize.sp,
                            color: Colors.white38,
                          ),
                        ),

                      SizedBox(height: gap),

                      // Options — 2×2 grid using fixed-height rows
                      ...List.generate(2, (row) {
                        final startIdx = row * 2;
                        return Padding(
                          padding:
                              EdgeInsets.only(bottom: row == 0 ? gap * 0.6 : 0),
                          child: Row(
                            children: List.generate(2, (col) {
                              final idx = startIdx + col;
                              if (idx >= question.options.length) {
                                return const Expanded(child: SizedBox());
                              }
                              final option = question.options[idx];
                              final isSelected = selectedAnswer == option;
                              final isCorrect =
                                  option == question.correctAnswer;

                              Color bgColor = Colors.white.withOpacity(0.08);
                              Color borderColor = Colors.white12;
                              Color textColor = Colors.white70;

                              if (answered) {
                                if (isSelected && isCorrect) {
                                  bgColor = MathChampTheme.correctAnswer
                                      .withOpacity(0.25);
                                  borderColor = MathChampTheme.correctAnswer;
                                  textColor = MathChampTheme.correctAnswer;
                                } else if (isSelected && !isCorrect) {
                                  bgColor = MathChampTheme.wrongAnswer
                                      .withOpacity(0.25);
                                  borderColor = MathChampTheme.wrongAnswer;
                                  textColor = MathChampTheme.wrongAnswer;
                                } else if (isCorrect) {
                                  bgColor = MathChampTheme.correctAnswer
                                      .withOpacity(0.1);
                                  borderColor = MathChampTheme.correctAnswer
                                      .withOpacity(0.5);
                                  textColor = MathChampTheme.correctAnswer
                                      .withOpacity(0.7);
                                }
                              }

                              return Expanded(
                                child: Padding(
                                  padding: EdgeInsets.only(
                                      right: col == 0 ? 5.w : 0),
                                  child: GestureDetector(
                                    onTap:
                                        answered ? null : () => onTap(option),
                                    child: AnimatedContainer(
                                      duration:
                                          const Duration(milliseconds: 250),
                                      height: gridItemH,
                                      decoration: BoxDecoration(
                                        color: bgColor,
                                        borderRadius:
                                            BorderRadius.circular(12.w),
                                        border: Border.all(
                                            color: borderColor, width: 1.5),
                                      ),
                                      alignment: Alignment.center,
                                      child: Text(
                                        '$option',
                                        style: GoogleFonts.fredoka(
                                          fontSize: optionFontSize.sp,
                                          fontWeight: FontWeight.bold,
                                          color: textColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        );
                      }),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mini score chip in top bar ──
class _MiniScore extends StatelessWidget {
  final Color color;
  final int score;
  final String emoji;
  const _MiniScore(
      {required this.color, required this.score, required this.emoji});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10.w),
      ),
      child: Text(
        '$emoji $score',
        style: GoogleFonts.fredoka(
            fontSize: 14.sp, color: Colors.white, fontWeight: FontWeight.bold),
      ),
    );
  }
}

// ══════════════════════════════════════════════════════
// ── 2-Player Result Dialog ──
// ══════════════════════════════════════════════════════

void showTwoPlayerResultDialog({
  required BuildContext context,
  required String player1Name,
  required String player2Name,
  required int p1Correct,
  required int p1Wrong,
  required int p2Correct,
  required int p2Wrong,
  required int totalQuestions,
  required int timeTaken,
}) {
  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => _TwoPlayerResultDialog(
      player1Name: player1Name,
      player2Name: player2Name,
      p1Correct: p1Correct,
      p1Wrong: p1Wrong,
      p2Correct: p2Correct,
      p2Wrong: p2Wrong,
      totalQuestions: totalQuestions,
      timeTaken: timeTaken,
      parentContext: context,
    ),
  );
}

class _TwoPlayerResultDialog extends StatefulWidget {
  final String player1Name;
  final String player2Name;
  final int p1Correct;
  final int p1Wrong;
  final int p2Correct;
  final int p2Wrong;
  final int totalQuestions;
  final int timeTaken;
  final BuildContext parentContext;

  const _TwoPlayerResultDialog({
    required this.player1Name,
    required this.player2Name,
    required this.p1Correct,
    required this.p1Wrong,
    required this.p2Correct,
    required this.p2Wrong,
    required this.totalQuestions,
    required this.timeTaken,
    required this.parentContext,
  });

  @override
  State<_TwoPlayerResultDialog> createState() => _TwoPlayerResultDialogState();
}

class _TwoPlayerResultDialogState extends State<_TwoPlayerResultDialog>
    with SingleTickerProviderStateMixin {
  late AnimationController _ctrl;
  late Animation<double> _scaleAnim;

  bool _isSharing = false;
  final GlobalKey _shareCardKey = GlobalKey();
  // Key on the share button — needed for iPad popover anchor
  final GlobalKey _shareButtonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _scaleAnim = CurvedAnimation(parent: _ctrl, curve: Curves.elasticOut);
    _ctrl.forward();
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  // winner: 0 = P1 wins, 1 = P2 wins, -1 = tie
  int get _winner {
    if (widget.p1Correct > widget.p2Correct) return 0;
    if (widget.p2Correct > widget.p1Correct) return 1;
    return -1;
  }

  Future<void> _shareResult() async {
    if (_isSharing) return;
    setState(() => _isSharing = true);

    try {
      await Future.delayed(const Duration(milliseconds: 80));

      final RenderRepaintBoundary boundary = _shareCardKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;

      final ui.Image image = await boundary.toImage(pixelRatio: 3.0);
      final ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);

      if (byteData == null) return;

      final Uint8List pngBytes = byteData.buffer.asUint8List();

      const playStoreLink =
          'https://play.google.com/store/apps/details?id=com.tsanalysis.mathchamp&pcampaignid=web_share';

      final isTie = _winner == -1;
      final p1Wins = _winner == 0;
      final winnerName = isTie
          ? 'It\'s a Tie'
          : (p1Wins ? widget.player1Name : widget.player2Name);

      final p1Accuracy = widget.totalQuestions == 0
          ? 0
          : (widget.p1Correct * 100 ~/ widget.totalQuestions);
      final p2Accuracy = widget.totalQuestions == 0
          ? 0
          : (widget.p2Correct * 100 ~/ widget.totalQuestions);

      final shareText = isTie
          ? '🤝 $winnerName on MathChamp!\n'
              '🔵 ${widget.player1Name}: ${widget.p1Correct}/${widget.totalQuestions} ($p1Accuracy%)\n'
              '🔴 ${widget.player2Name}: ${widget.p2Correct}/${widget.totalQuestions} ($p2Accuracy%)\n'
              '⏱ Total Time: ${widget.timeTaken}s\n'
              '🎮 Download MathChamp!\n$playStoreLink'
          : '🏆 $winnerName wins on MathChamp!\n'
              '🔵 ${widget.player1Name}: ${widget.p1Correct}/${widget.totalQuestions} ($p1Accuracy%)\n'
              '🔴 ${widget.player2Name}: ${widget.p2Correct}/${widget.totalQuestions} ($p2Accuracy%)\n'
              '⏱ Total Time: ${widget.timeTaken}s\n'
              '🎮 Download MathChamp!\n$playStoreLink';

      // Get the share button's position for iPad popover anchor
      final box =
          _shareButtonKey.currentContext?.findRenderObject() as RenderBox?;
      final origin = box != null
          ? box.localToGlobal(Offset.zero) & box.size
          : const Rect.fromLTWH(0, 0, 100, 100);

      await Share.shareXFiles(
        [
          XFile.fromData(
            pngBytes,
            name: 'mathchamp_2player_result.png',
            mimeType: 'image/png',
          ),
        ],
        text: shareText,
        sharePositionOrigin: origin,
      );
      AnalyticsService.instance.logTwoPlayerResultShared();
    } catch (e) {
      debugPrint('Share failed: $e');
    } finally {
      if (mounted) setState(() => _isSharing = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTie = _winner == -1;
    final p1Wins = _winner == 0;

    final winnerName = isTie
        ? 'It\'s a Tie!'
        : (p1Wins ? widget.player1Name : widget.player2Name);
    final winnerColor = isTie
        ? const Color(0xFFFFD93D)
        : (p1Wins ? const Color(0xFF6C63FF) : const Color(0xFFFF6B6B));
    final winnerEmoji = isTie ? '🤝' : (p1Wins ? '🔵' : '🔴');
    final winnerTrophy = isTie ? '🏅' : '🏆';

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        Navigator.of(context).pop();
        widget.parentContext.pop();
      },
      child: ScaleTransition(
        scale: _scaleAnim,
        child: Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 32.w),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(32.w),
              boxShadow: [
                BoxShadow(
                  color: winnerColor.withOpacity(0.4),
                  blurRadius: 30,
                  offset: const Offset(0, 15),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // ── Shareable card ──
                  RepaintBoundary(
                    key: _shareCardKey,
                    child: Container(
                      color: Colors.white,
                      padding: EdgeInsets.fromLTRB(24.w, 24.w, 24.w, 16.w),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // Trophy + winner emoji
                          Text(winnerTrophy, style: TextStyle(fontSize: 60.sp)),
                          SizedBox(height: 8.w),

                          // Winner banner
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 20.w, vertical: 10.w),
                            decoration: BoxDecoration(
                              color: winnerColor.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20.w),
                              border: Border.all(color: winnerColor, width: 2),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(winnerEmoji,
                                    style: TextStyle(fontSize: 22.sp)),
                                SizedBox(width: 8.w),
                                Flexible(
                                  child: Text(
                                    isTie
                                        ? 'It\'s a Tie!'
                                        : '$winnerName Wins!',
                                    style: GoogleFonts.fredoka(
                                      fontSize: 22.sp,
                                      fontWeight: FontWeight.bold,
                                      color: winnerColor,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 20.w),

                          // ── Score comparison ──
                          Row(
                            children: [
                              Expanded(
                                child: _PlayerResultCard(
                                  name: widget.player1Name,
                                  emoji: '🔵',
                                  color: const Color(0xFF6C63FF),
                                  correct: widget.p1Correct,
                                  wrong: widget.p1Wrong,
                                  total: widget.totalQuestions,
                                  isWinner: _winner == 0,
                                ),
                              ),
                              SizedBox(width: 10.w),
                              Expanded(
                                child: _PlayerResultCard(
                                  name: widget.player2Name,
                                  emoji: '🔴',
                                  color: const Color(0xFFFF6B6B),
                                  correct: widget.p2Correct,
                                  wrong: widget.p2Wrong,
                                  total: widget.totalQuestions,
                                  isWinner: _winner == 1,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 16.w),

                          // Time taken
                          Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 16.w, vertical: 10.w),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8F9FA),
                              borderRadius: BorderRadius.circular(16.w),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('⏱', style: TextStyle(fontSize: 20.sp)),
                                SizedBox(width: 8.w),
                                Text(
                                  'Total Time: ${widget.timeTaken}s',
                                  style: GoogleFonts.nunito(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF636E72),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 14.w),

                          // MathChamp branding
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Image.asset(
                                'assets/logo.png',
                                width: 24.w,
                                height: 24.w,
                                fit: BoxFit.contain,
                              ),
                              SizedBox(width: 6.w),
                              Text(
                                'MathChamp',
                                style: GoogleFonts.fredoka(
                                  fontSize: 13.sp,
                                  color: const Color(0xFF6C63FF),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),

                  // ── Buttons ──
                  Padding(
                    padding: EdgeInsets.fromLTRB(24.w, 4.w, 24.w, 24.w),
                    child: Row(
                      children: [
                        // Share button
                        Expanded(
                          child: GestureDetector(
                            key: _shareButtonKey,
                            onTap: _isSharing ? null : _shareResult,
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: EdgeInsets.symmetric(vertical: 15.w),
                              decoration: BoxDecoration(
                                gradient: const LinearGradient(
                                  colors: [
                                    Color(0xFF6BCB77),
                                    Color(0xFF4ECDC4)
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
                                          Icon(Icons.share_rounded,
                                              color: Colors.white, size: 20.w),
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
                        // Close / play again button
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.of(context).pop();
                              widget.parentContext.pop();
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 15.w),
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: isTie
                                      ? [
                                          const Color(0xFFFFD93D),
                                          const Color(0xFFFFA726)
                                        ]
                                      : p1Wins
                                          ? [
                                              const Color(0xFF6C63FF),
                                              const Color(0xFF8B5CF6)
                                            ]
                                          : [
                                              const Color(0xFFFF6B6B),
                                              const Color(0xFFFF8E53)
                                            ],
                                ),
                                borderRadius: BorderRadius.circular(20.w),
                                boxShadow: [
                                  BoxShadow(
                                    color: winnerColor.withOpacity(0.4),
                                    blurRadius: 12,
                                    offset: const Offset(0, 6),
                                  ),
                                ],
                              ),
                              child: Center(
                                child: Text(
                                  isTie ? 'Play Again 🤝' : 'GG! Again? 🎮',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 17.sp,
                                    fontWeight: FontWeight.bold,
                                    color: isTie
                                        ? const Color(0xFF2D3436)
                                        : Colors.white,
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
        ),
      ),
    );
  }
}

// ── Per-player result card ──
class _PlayerResultCard extends StatelessWidget {
  final String name;
  final String emoji;
  final Color color;
  final int correct;
  final int wrong;
  final int total;
  final bool isWinner;

  const _PlayerResultCard({
    required this.name,
    required this.emoji,
    required this.color,
    required this.correct,
    required this.wrong,
    required this.total,
    required this.isWinner,
  });

  @override
  Widget build(BuildContext context) {
    final accuracy = total == 0 ? 0.0 : correct / total;

    return Container(
      padding: EdgeInsets.all(14.w),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(20.w),
        border: Border.all(
          color: isWinner ? color : color.withOpacity(0.2),
          width: isWinner ? 2.5 : 1,
        ),
      ),
      child: Column(
        children: [
          if (isWinner) Text('👑', style: TextStyle(fontSize: 20.sp)),
          Text(emoji, style: TextStyle(fontSize: 22.sp)),
          SizedBox(height: 4.w),
          Text(
            name,
            style: GoogleFonts.fredoka(
              fontSize: 14.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
          ),
          SizedBox(height: 10.w),
          // Big score
          Text(
            '$correct / $total',
            style: GoogleFonts.fredoka(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          Text(
            'correct',
            style: GoogleFonts.nunito(
                fontSize: 11.sp, color: const Color(0xFF636E72)),
          ),
          SizedBox(height: 8.w),
          // Accuracy bar
          ClipRRect(
            borderRadius: BorderRadius.circular(6.w),
            child: LinearProgressIndicator(
              value: accuracy,
              minHeight: 8.w,
              backgroundColor: color.withOpacity(0.15),
              valueColor: AlwaysStoppedAnimation(color),
            ),
          ),
          SizedBox(height: 4.w),
          Text(
            '${(accuracy * 100).toStringAsFixed(0)}% accuracy',
            style: GoogleFonts.nunito(
                fontSize: 11.sp, color: const Color(0xFF636E72)),
          ),
          SizedBox(height: 6.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text('❌$wrong',
                  style: GoogleFonts.nunito(
                      fontSize: 12.sp,
                      color: MathChampTheme.wrongAnswer,
                      fontWeight: FontWeight.bold)),
            ],
          ),
        ],
      ),
    );
  }
}
