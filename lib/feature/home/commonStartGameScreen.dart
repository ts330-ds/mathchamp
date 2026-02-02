import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailCubit.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailState.dart';
import 'package:mathchamp/feature/questions/cubit/questionState.dart';
import 'package:mathchamp/utils/custom_theme.dart';

import '../../ads/adsCubit.dart';
import '../../ads/adsState.dart';
import '../../routes/paths.dart';
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
                    _buildGameInfoCard(context, state),
                    SizedBox(height: 20.w),
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
                    // Banner Ad
                    BlocBuilder<AdCubit, AdsState>(
                      builder: (context, state) {
                        if (state.common_bannerAd != null) {
                          return Center(
                            child: SizedBox(
                              width: state.common_bannerAd!.size.width.toDouble(),
                              height: state.common_bannerAd!.size.height.toDouble(),
                              child: AdWidget(ad: state.common_bannerAd!),
                            ),
                          );
                        }
                        return const SizedBox.shrink();
                      },
                    ),
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

        return GestureDetector(
          onTap: () {
            questionsCubit.generateQuestions(
              numberOfQuestions: state.numberOfQuestions ?? 10,
              range: state.selectedDifficulty ?? ("Easy", 10),
              gameHeading: state.gameHeading ?? 'Addition',
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
        );
      },
    );
  }
}
