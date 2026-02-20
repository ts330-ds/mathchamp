import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailCubit.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailState.dart';
import 'package:mathchamp/feature/questions/cubit/questionState.dart';
import 'package:mathchamp/feature/setting/cubit/settingCubit.dart';
import 'package:mathchamp/utils/custom_theme.dart';

import '../../ads/unitIds.dart';
import '../../routes/paths.dart';
import '../../services/analyticsService.dart';
import '../questions/cubit/questionCubit.dart';

class CommonStartGamescreen extends StatelessWidget {
  const CommonStartGamescreen({super.key});

  String _getGameEmoji(String? gameName) {
    switch (gameName) {
      case "Addition":
        return "+";
      case "Subtraction":
        return "-";
      case "Multiplication":
        return "×";
      case "Division":
        return "÷";
      case "Multiplication Tables":
        return "📊";
      case "Mixed":
        return "🎲";
      case "Square Root":
        return "√";
      case "Powers":
        return "²";
      default:
        return "🔢";
    }
  }

  @override
  Widget build(BuildContext context) {
    // Log screen view once per navigation
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AnalyticsService.instance.logScreen('common_start_game_screen');
    });
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF8F9FA),
                Color(0xFFE8F4FD),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: BlocBuilder<GameDetailCubit, GameDetailState>(
              builder: (context, state) {
                final cubit = context.read<GameDetailCubit>();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildHeader(context, state),
                    SizedBox(height: 20.w),
                    // Game Info Card
                    // Settings Section
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Questions Count Selector
                            _buildQuestionsSelector(context, state, cubit),
                            SizedBox(height: 16.w),
                            // Difficulty Selector
                            if (state.difficulty!.length > 1)
                              _buildDifficultySelector(context, state),
                          ],
                        ),
                      ),
                    ),
                    // Start Button
                    _buildStartButton(context, state),
                    SizedBox(height: 10.w),
                    // Banner Ad — uses its own BannerAd instance to avoid
                    // "AdWidget already in widget tree" error in release mode
                    const _CommonBannerAd(),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, GameDetailState state) {
    return Row(
      children: [
        // Back Button
        GestureDetector(
          onTap: () {
            final cubit = context.read<QuestionsCubit>();
            cubit.setLoading(false);
            context.pop();
          },
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              color: const Color(0xFF6C63FF),
              size: 24.w,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        // Title
        Expanded(
          child: Text(
            'Get Ready!',
            style: GoogleFonts.fredoka(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3436),
            ),
          ),
        ),
        // Fun decoration
        Text(
          '🎮',
          style: TextStyle(fontSize: 32.sp),
        ),
      ],
    );
  }

  Widget _buildGameInfoCard(BuildContext context, GameDetailState state) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(24.w),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.4),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          // Game Icon
          Container(
            width: 70.w,
            height: 70.w,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: Center(
              child: Text(
                _getGameEmoji(state.gameHeading),
                style: GoogleFonts.fredoka(
                  fontSize: 36.sp,
                  color: const Color(0xFF6C63FF),
                ),
              ),
            ),
          ),
          SizedBox(width: 16.w),
          // Game Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  state.gameHeading ?? 'Math Quiz',
                  style: GoogleFonts.fredoka(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 4.w),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12.w),
                  ),
                  child: Text(
                    '${state.firstDigit ?? 1} × ${state.lastDigit ?? 1} Digits',
                    style: GoogleFonts.nunito(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          // Stars
          Column(
            children: [
              Text('⭐', style: TextStyle(fontSize: 20.sp)),
              Text('⭐', style: TextStyle(fontSize: 20.sp)),
              Text('⭐', style: TextStyle(fontSize: 20.sp)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuestionsSelector(
      BuildContext context, GameDetailState state, GameDetailCubit cubit) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFD93D).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.w),
                ),
                child: Text(
                  '📝',
                  style: TextStyle(fontSize: 24.sp),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Number of Questions',
                style: GoogleFonts.fredoka(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.w),
          // Question count buttons
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [5, 10, 15, 20].map((count) {
              bool isSelected = state.numberOfQuestions == count;
              return GestureDetector(
                onTap: () => cubit.selectNoOfQuestion(count),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 60.w,
                  height: 60.w,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
                          )
                        : null,
                    color: isSelected ? null : const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(16.w),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF6C63FF).withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$count',
                      style: GoogleFonts.fredoka(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : const Color(0xFF636E72),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDifficultySelector(BuildContext context, GameDetailState state) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: EdgeInsets.all(10.w),
                decoration: BoxDecoration(
                  color: const Color(0xFF6BCB77).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.w),
                ),
                child: Text(
                  '🎯',
                  style: TextStyle(fontSize: 24.sp),
                ),
              ),
              SizedBox(width: 12.w),
              Text(
                'Select Difficulty Range',
                style: GoogleFonts.fredoka(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
            ],
          ),
          SizedBox(height: 16.w),
          // Difficulty options
          ...List.generate(state.difficulty!.length, (index) {
            final (label, number, isChecked) = state.difficulty![index];
            Color difficultyColor;
            String emoji;

            if (label.contains('Easy')) {
              difficultyColor = MathChampTheme.ageGroup4to6;
              emoji = '🌟';
            } else if (label.contains('Medium')) {
              difficultyColor = MathChampTheme.ageGroup7to9;
              emoji = '⭐';
            } else {
              difficultyColor = MathChampTheme.ageGroup10to12;
              emoji = '🏆';
            }

            return GestureDetector(
              onTap: () => context.read<GameDetailCubit>().toggle(index),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: EdgeInsets.only(bottom: 10.w),
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
                decoration: BoxDecoration(
                  color: isChecked
                      ? difficultyColor.withOpacity(0.15)
                      : const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(16.w),
                  border: Border.all(
                    color: isChecked ? difficultyColor : Colors.transparent,
                    width: 2,
                  ),
                ),
                child: Row(
                  children: [
                    // Checkbox
                    AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      width: 28.w,
                      height: 28.w,
                      decoration: BoxDecoration(
                        color: isChecked ? difficultyColor : Colors.white,
                        borderRadius: BorderRadius.circular(8.w),
                        border: Border.all(
                          color: isChecked
                              ? difficultyColor
                              : const Color(0xFFDDDDDD),
                          width: 2,
                        ),
                      ),
                      child: isChecked
                          ? Icon(
                              Icons.check_rounded,
                              color: Colors.white,
                              size: 18.w,
                            )
                          : null,
                    ),
                    SizedBox(width: 12.w),
                    // Emoji
                    Text(emoji, style: TextStyle(fontSize: 20.sp)),
                    SizedBox(width: 8.w),
                    // Label
                    Expanded(
                      child: Text(
                        '$label (0 < $number)',
                        style: GoogleFonts.nunito(
                          fontSize: 16.sp,
                          fontWeight: FontWeight.w600,
                          color: isChecked
                              ? difficultyColor
                              : const Color(0xFF636E72),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildStartButton(BuildContext context, GameDetailState state) {
    return BlocBuilder<QuestionsCubit, QuestionState>(
      builder: (context, questionState) {
        final questionsCubit = context.read<QuestionsCubit>();

        if (questionState.isLoading) {
          return Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(vertical: 18.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
              ),
              borderRadius: BorderRadius.circular(20.w),
            ),
            child: Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: const CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 3,
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Text(
                    'Preparing Quiz...',
                    style: GoogleFonts.fredoka(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return Column(
          children: [
            // ── Single Player ──
            GestureDetector(
              onTap: () {
                final gameType = state.gameHeading ?? 'Addition';
                final numQ = state.numberOfQuestions ?? 10;
                final diff = state.selectedDifficulty?.$1 ?? 'Easy';
                AnalyticsService.instance.logQuizStarted(
                  gameType: gameType,
                  numberOfQuestions: numQ,
                  difficulty: diff,
                );
                questionsCubit.generateQuestions(
                  numberOfQuestions: numQ,
                  range: state.selectedDifficulty ?? ("Easy", 10),
                  gameHeading: gameType,
                  firstDigit: state.firstDigit ?? 1,
                  lastDigit: state.lastDigit ?? 1,
                );
                context.push(Paths.questionScreen);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 18.w),
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
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Let's Go!",
                      style: GoogleFonts.fredoka(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFD93D),
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      child: Icon(
                        Icons.play_arrow_rounded,
                        color: const Color(0xFF2D3436),
                        size: 24.w,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 12.w),
            // ── 2 Player ──
            GestureDetector(
              onTap: () {
                AnalyticsService.instance.logTwoPlayerModeOpened(
                  state.gameHeading ?? 'Addition',
                );
                _show2PlayerNameDialog(context, state, questionsCubit);
              },
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.symmetric(vertical: 18.w),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)],
                  ),
                  borderRadius: BorderRadius.circular(20.w),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFFFF6B6B).withOpacity(0.4),
                      blurRadius: 15,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '2 Player Mode',
                      style: GoogleFonts.fredoka(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(width: 8.w),
                    Container(
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.3),
                        borderRadius: BorderRadius.circular(10.w),
                      ),
                      child: Text('👥', style: TextStyle(fontSize: 20.sp)),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _show2PlayerNameDialog(
      BuildContext context,
      GameDetailState state,
      QuestionsCubit questionsCubit) {
    final p1Controller = TextEditingController();
    final p2Controller = TextEditingController();
    final formKey = GlobalKey<FormState>();

    // Read saved user names from SettingsCubit
    final userList =
        context.read<SettingsCubit>().state.userList;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) {
          // Helper: build a row of tappable name chips
          Widget buildNameChips(
              List<String> names,
              TextEditingController ctrl,
              Color chipColor) {
            if (names.isEmpty) return const SizedBox.shrink();
            return Wrap(
              spacing: 8.w,
              runSpacing: 6.w,
              children: names.map((name) {
                final isSelected =
                    ctrl.text.trim().toLowerCase() == name.toLowerCase();
                return GestureDetector(
                  onTap: () {
                    setDialogState(() => ctrl.text = name);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: EdgeInsets.symmetric(
                        horizontal: 14.w, vertical: 7.w),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? chipColor.withOpacity(0.18)
                          : const Color(0xFFF0F0F0),
                      borderRadius: BorderRadius.circular(20.w),
                      border: Border.all(
                        color: isSelected ? chipColor : Colors.transparent,
                        width: 1.5,
                      ),
                    ),
                    child: Text(
                      name,
                      style: GoogleFonts.fredoka(
                        fontSize: 14.sp,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? chipColor
                            : const Color(0xFF636E72),
                      ),
                    ),
                  ),
                );
              }).toList(),
            );
          }

          return Dialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28.w)),
            child: SingleChildScrollView(
              child: Padding(
                padding: EdgeInsets.all(24.w),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Header ──
                      Center(
                        child: Column(
                          children: [
                            Text('👥',
                                style: TextStyle(fontSize: 48.sp)),
                            SizedBox(height: 8.w),
                            Text(
                              '2 Player Mode',
                              style: GoogleFonts.fredoka(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2D3436),
                              ),
                            ),
                            SizedBox(height: 4.w),
                            Text(
                              userList.isEmpty
                                  ? 'Enter names for both players'
                                  : 'Choose or type player names',
                              style: GoogleFonts.nunito(
                                  fontSize: 14.sp,
                                  color: const Color(0xFF636E72)),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 20.w),

                      // ── Player 1 ──
                      Row(
                        children: [
                          Text('🔵',
                              style: TextStyle(fontSize: 18.sp)),
                          SizedBox(width: 8.w),
                          Text(
                            'Player 1',
                            style: GoogleFonts.fredoka(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF6C63FF),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.w),
                      // Chips for P1
                      buildNameChips(userList, p1Controller,
                          const Color(0xFF6C63FF)),
                      if (userList.isNotEmpty) SizedBox(height: 10.w),
                      TextFormField(
                        controller: p1Controller,
                        onChanged: (_) => setDialogState(() {}),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Enter Player 1 name'
                                : null,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(10.w),
                            child: Text('🔵',
                                style: TextStyle(fontSize: 18.sp)),
                          ),
                          hintText: 'Player 1 Name',
                          hintStyle: GoogleFonts.nunito(
                              color: const Color(0xFF9E9E9E)),
                        ),
                        style: GoogleFonts.fredoka(fontSize: 16.sp),
                        textCapitalization: TextCapitalization.words,
                      ),

                      SizedBox(height: 18.w),

                      // ── Player 2 ──
                      Row(
                        children: [
                          Text('🔴',
                              style: TextStyle(fontSize: 18.sp)),
                          SizedBox(width: 8.w),
                          Text(
                            'Player 2',
                            style: GoogleFonts.fredoka(
                              fontSize: 15.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFFFF6B6B),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8.w),
                      // Chips for P2
                      buildNameChips(userList, p2Controller,
                          const Color(0xFFFF6B6B)),
                      if (userList.isNotEmpty) SizedBox(height: 10.w),
                      TextFormField(
                        controller: p2Controller,
                        onChanged: (_) => setDialogState(() {}),
                        validator: (v) =>
                            (v == null || v.trim().isEmpty)
                                ? 'Enter Player 2 name'
                                : null,
                        decoration: InputDecoration(
                          prefixIcon: Padding(
                            padding: EdgeInsets.all(10.w),
                            child: Text('🔴',
                                style: TextStyle(fontSize: 18.sp)),
                          ),
                          hintText: 'Player 2 Name',
                          hintStyle: GoogleFonts.nunito(
                              color: const Color(0xFF9E9E9E)),
                        ),
                        style: GoogleFonts.fredoka(fontSize: 16.sp),
                        textCapitalization: TextCapitalization.words,
                      ),

                      SizedBox(height: 24.w),

                      // ── Buttons ──
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => Navigator.of(ctx).pop(),
                              child: Container(
                                padding:
                                    EdgeInsets.symmetric(vertical: 14.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFF0F0F0),
                                  borderRadius:
                                      BorderRadius.circular(16.w),
                                ),
                                child: Center(
                                  child: Text(
                                    'Cancel',
                                    style: GoogleFonts.fredoka(
                                        fontSize: 16.sp,
                                        color: const Color(0xFF636E72)),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(width: 12.w),
                          Expanded(
                            child: GestureDetector(
                              onTap: () {
                                if (!formKey.currentState!.validate())
                                  return;
                                final p1 =
                                    p1Controller.text.trim();
                                final p2 =
                                    p2Controller.text.trim();
                                Navigator.of(ctx).pop();
                                final gameType = state.gameHeading ?? 'Addition';
                                final numQ = state.numberOfQuestions ?? 10;
                                final diff = state.selectedDifficulty?.$1 ?? 'Easy';
                                AnalyticsService.instance.logTwoPlayerGameStarted(
                                  gameType: gameType,
                                  numberOfQuestions: numQ,
                                  difficulty: diff,
                                  player1Name: p1,
                                  player2Name: p2,
                                );
                                questionsCubit.generateQuestions(
                                  numberOfQuestions: numQ,
                                  range: state.selectedDifficulty ??
                                      ("Easy", 10),
                                  gameHeading: gameType,
                                  firstDigit: state.firstDigit ?? 1,
                                  lastDigit: state.lastDigit ?? 1,
                                );
                                context.push(
                                  Paths.player_2_screen,
                                  extra: {
                                    'player1': p1,
                                    'player2': p2
                                  },
                                );
                              },
                              child: Container(
                                padding:
                                    EdgeInsets.symmetric(vertical: 14.w),
                                decoration: BoxDecoration(
                                  gradient: const LinearGradient(
                                    colors: [
                                      Color(0xFFFF6B6B),
                                      Color(0xFFFF8E53)
                                    ],
                                  ),
                                  borderRadius:
                                      BorderRadius.circular(16.w),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFFFF6B6B)
                                          .withOpacity(0.4),
                                      blurRadius: 10,
                                      offset: const Offset(0, 5),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Text(
                                    "Let's Play! 🎮",
                                    style: GoogleFonts.fredoka(
                                      fontSize: 16.sp,
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
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

// ── Self-contained banner that owns its BannerAd lifecycle ──────────────────
// Each navigation to CommonStartGamescreen creates a NEW instance of this
// widget, which loads a fresh BannerAd. This prevents the
// "AdWidget is already in the widget tree" crash in release mode.
class _CommonBannerAd extends StatefulWidget {
  const _CommonBannerAd();

  @override
  State<_CommonBannerAd> createState() => _CommonBannerAdState();
}

class _CommonBannerAdState extends State<_CommonBannerAd> {
  BannerAd? _bannerAd;
  AdSize? _adSize;
  bool _isLoaded = false;

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  Future<void> _loadAd() async {
    AdSize adSize;
    try {
      final adaptive =
          await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
        MediaQuery.of(context).size.width.truncate(),
      );
      adSize = adaptive ?? AdSize.banner;
    } catch (_) {
      adSize = AdSize.banner;
    }

    final banner = BannerAd(
      adUnitId: UnitIds.common_bannerUnitID,
      size: adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) {
            setState(() {
              _bannerAd = ad as BannerAd;
              _adSize = adSize;
              _isLoaded = true;
            });
          }
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );

    banner.load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isLoaded || _bannerAd == null || _adSize == null) {
      return const SizedBox.shrink();
    }
    return SizedBox(
      width: double.infinity,
      height: _adSize!.height.toDouble(),
      child: AdWidget(ad: _bannerAd!),
    );
  }
}
