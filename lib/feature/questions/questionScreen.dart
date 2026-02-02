import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathchamp/ads/adsCubit.dart';
import 'package:mathchamp/ads/adsState.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailCubit.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailState.dart';
import 'package:mathchamp/feature/questions/cubit/questionCubit.dart';
import 'package:mathchamp/feature/questions/cubit/questionState.dart';
import 'package:mathchamp/feature/questions/widget/gameCompleteDialog.dart';
import 'package:mathchamp/feature/setting/cubit/settingCubit.dart';
import 'package:mathchamp/feature/setting/cubit/settingState.dart';
import 'package:mathchamp/utils/custom_theme.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  Future<bool?> _showQuitDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24.w),
        ),
        child: Padding(
          padding: EdgeInsets.all(24.w),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                '😢',
                style: TextStyle(fontSize: 48.sp),
              ),
              SizedBox(height: 16.w),
              Text(
                'Quit Quiz?',
                style: GoogleFonts.fredoka(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xFF2D3436),
                ),
              ),
              SizedBox(height: 8.w),
              Text(
                'Are you sure you want to leave?\nYour progress will be lost!',
                textAlign: TextAlign.center,
                style: GoogleFonts.nunito(
                  fontSize: 16.sp,
                  color: const Color(0xFF636E72),
                ),
              ),
              SizedBox(height: 24.w),
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(false),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F0F0),
                          borderRadius: BorderRadius.circular(16.w),
                        ),
                        child: Center(
                          child: Text(
                            'Stay',
                            style: GoogleFonts.fredoka(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF636E72),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  Expanded(
                    child: GestureDetector(
                      onTap: () => Navigator.of(context).pop(true),
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 14.w),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFFF6B6B), Color(0xFFFF8E8E)],
                          ),
                          borderRadius: BorderRadius.circular(16.w),
                        ),
                        child: Center(
                          child: Text(
                            'Quit',
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
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await _showQuitDialog(context);
        if (!context.mounted) return;
        if (shouldExit == true) {
          Navigator.of(context).pop();
        }
      },
      child: SafeArea(
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
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, settingState) {
                return BlocBuilder<GameDetailCubit, GameDetailState>(
                  builder: (context, gameState) {
                    return BlocConsumer<QuestionsCubit, QuestionState>(
                      listener: (context, state) {
                        if (state.gameCompleted == true) {
                          final adCubit = context.read<AdCubit>();

                          if (adCubit.state.rewardedAd != null) {
                            adCubit.showRewardedAd((reward) {
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                showCongratsDialog(
                                  context,
                                  settingState.currentUser ?? "Math Champion",
                                  state.totalTimeTaken?.inSeconds ?? 0,
                                  gameState.firstDigit!,
                                  gameState.lastDigit!,
                                  gameState.gameHeading ?? "Addition",
                                );
                              });
                            });
                          } else {
                            showCongratsDialog(
                              context,
                              settingState.currentUser ?? "Math Champion",
                              state.totalTimeTaken?.inSeconds ?? 0,
                              gameState.firstDigit!,
                              gameState.lastDigit!,
                              gameState.gameHeading ?? "Addition",
                            );
                          }
                        }
                      },
                      builder: (context, state) {
                        final cubit = context.read<QuestionsCubit>();
                        if (state.questions.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 60.w,
                                  height: 60.w,
                                  child: const CircularProgressIndicator(
                                    color: Color(0xFF6C63FF),
                                    strokeWidth: 4,
                                  ),
                                ),
                                SizedBox(height: 20.w),
                                Text(
                                  'Preparing your quiz...',
                                  style: GoogleFonts.fredoka(
                                    fontSize: 18.sp,
                                    color: const Color(0xFF6C63FF),
                                  ),
                                ),
                              ],
                            ),
                          );
                        }
                        final question = state.questions[state.currentIndex];
                        return Padding(
                          padding: EdgeInsets.all(16.w),
                          child: Column(
                            children: [
                              // Header
                              _buildHeader(context, state),
                              SizedBox(height: 16.w),
                              // Progress Bar
                              _buildProgressBar(state),
                              SizedBox(height: 24.w),
                              // Question Card
                              _buildQuestionCard(context, question),
                              SizedBox(height: 24.w),
                              // Options Grid
                              Expanded(
                                child: _buildOptionsGrid(
                                    context, state, question, cubit),
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context, QuestionState state) {
    return Row(
      children: [
        // Back Button
        GestureDetector(
          onTap: () async {
            final shouldExit = await _showQuitDialog(context);
            if (!context.mounted) return;
            if (shouldExit == true) {
              context.pop();
            }
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
              Icons.close_rounded,
              color: const Color(0xFFFF6B6B),
              size: 24.w,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        // Title
        Expanded(
          child: Text(
            state.quizName ?? "Math Quiz",
            style: GoogleFonts.fredoka(
              fontSize: 22.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3436),
            ),
          ),
        ),
        // Question Counter Badge
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
            ),
            borderRadius: BorderRadius.circular(20.w),
          ),
          child: Text(
            '${state.currentIndex + 1}/${state.questions.length}',
            style: GoogleFonts.fredoka(
              fontSize: 16.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildProgressBar(QuestionState state) {
    double progress =
        (state.currentIndex + 1) / state.questions.length;
    return Container(
      height: 12.w,
      decoration: BoxDecoration(
        color: const Color(0xFFE0E0E0),
        borderRadius: BorderRadius.circular(6.w),
      ),
      child: Stack(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 500),
            curve: Curves.easeOutCubic,
            width: (320.w * progress).clamp(0, 320.w),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [Color(0xFF6BCB77), Color(0xFF4ECDC4)],
              ),
              borderRadius: BorderRadius.circular(6.w),
            ),
          ),//
          // Animated stars
          ...List.generate(state.questions.length, (index) {
            double position = (index + 1) / state.questions.length;
            bool isCompleted = index < state.currentIndex;
            return Positioned(
              left: (320.w * position) - 10.w,
              top: -4.w,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: isCompleted ? 1.0 : 0.3,
                child: Text(
                  isCompleted ? '⭐' : '☆',
                  style: TextStyle(fontSize: 16.sp),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildQuestionCard(BuildContext context, dynamic question) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(32.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(28.w),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.15),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(
            '🤔',
            style: TextStyle(fontSize: 40.sp),
          ),
          SizedBox(height: 16.w),
          Text(
            question.questionText,
            textAlign: TextAlign.center,
            style: GoogleFonts.fredoka(
              fontSize: 36.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3436),
            ),
          ),
          SizedBox(height: 8.w),
          Text(
            'Choose the correct answer!',
            style: GoogleFonts.nunito(
              fontSize: 14.sp,
              color: const Color(0xFF636E72),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsGrid(BuildContext context, QuestionState state,
      dynamic question, QuestionsCubit cubit) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 400),
      child: GridView.builder(
        key: ValueKey(state.currentIndex),
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.5,
          crossAxisSpacing: 16.w,
          mainAxisSpacing: 16.w,
        ),
        itemCount: question.options.length,
        itemBuilder: (context, index) {
          final option = question.options[index];
          final isSelected = state.selectedOption == option;
          final isCorrect = option == question.correctAnswer;

          // Colors for options
          Color bgColor = MathChampTheme.quizCardColors[
              index % MathChampTheme.quizCardColors.length];
          Color textColor = const Color(0xFF2D3436);

          if (isSelected) {
            bgColor = isCorrect
                ? MathChampTheme.correctAnswer
                : MathChampTheme.wrongAnswer;
            textColor = Colors.white;
          }

          return GestureDetector(
            onTap: () {
              cubit.selectOption(option);
              if (isCorrect) {
                Future.delayed(const Duration(milliseconds: 500), () {
                  cubit.nextQuestion();
                });
              }
            },
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(24.w),
                boxShadow: [
                  BoxShadow(
                    color: bgColor.withOpacity(0.4),
                    blurRadius: isSelected ? 15 : 10,
                    offset: Offset(0, isSelected ? 8 : 5),
                  ),
                ],
                border: isSelected
                    ? Border.all(
                        color: isCorrect
                            ? MathChampTheme.correctAnswer
                            : MathChampTheme.wrongAnswer,
                        width: 3,
                      )
                    : null,
              ),
              child: Stack(
                children: [
                  // Background decoration
                  Positioned(
                    top: -10.w,
                    right: -10.w,
                    child: Container(
                      width: 50.w,
                      height: 50.w,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                  // Content
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        // Selection indicator
                        if (isSelected)
                          Padding(
                            padding: EdgeInsets.only(bottom: 4.w),
                            child: Text(
                              isCorrect ? '✅' : '❌',
                              style: TextStyle(fontSize: 20.sp),
                            ),
                          ),
                        Text(
                          option.toString(),
                          style: GoogleFonts.fredoka(
                            fontSize: 28.sp,
                            fontWeight: FontWeight.bold,
                            color: textColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
