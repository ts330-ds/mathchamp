import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mathchamp/ads/adsCubit.dart';
import 'package:mathchamp/ads/adsState.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailCubit.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailState.dart';
import 'package:mathchamp/feature/questions/cubit/questionCubit.dart';
import 'package:mathchamp/feature/questions/cubit/questionState.dart';
import 'package:mathchamp/feature/questions/widget/gameCompleteDialog.dart';
import 'package:mathchamp/feature/setting/cubit/settingCubit.dart';
import 'package:mathchamp/feature/setting/cubit/settingState.dart';

import '../../customPainter/backButtonDesign.dart';
import '../../custom_widget/backButton3D.dart';

class QuestionScreen extends StatelessWidget {
  const QuestionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) return;
        final shouldExit = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
            title: Text(
              "Quit quiz",
              style: Theme.of(context).textTheme.labelMedium,
            ),
            content: const Text("Are you sure you want to quit?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(false),
                child: const Text("No"),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
                child: const Text("Yes"),
              ),
            ],
          ),
        );
        if (!context.mounted) return;
        if (shouldExit == true) {
          Navigator.of(context).pop(); // exit page
          // Or SystemNavigator.pop(); // exit the app completely
        }
      },
      child: SafeArea(
        child: Scaffold(
          body: BlocBuilder<SettingsCubit, SettingsState>(builder: (context, settingState) {
            return BlocBuilder<GameDetailCubit, GameDetailState>(builder: (context, gameState) {
              return BlocConsumer<QuestionsCubit, QuestionState>(
                listener: (context, state) {
                  if (state.gameCompleted == true) {
                    final adCubit = context.read<AdCubit>();

                    if (adCubit.state.rewardedAd != null) {
                      // Rewarded ad available → show it first
                      adCubit.showRewardedAd((reward) {
                        // ✅ Safe navigation / dialog after ad complete
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          showCongratsDialog(
                            context,
                            settingState.currentUser ?? "No Name",
                            state.totalTimeTaken?.inSeconds ?? 0,
                            gameState.firstDigit!,
                            gameState.lastDigit!,
                            gameState.gameHeading ?? "Addition",
                          );
                        });
                      });
                    } else {
                      // Rewarded ad not loaded → direct show dialog
                      showCongratsDialog(
                        context,
                        settingState.currentUser ?? "No Name",
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
                    return const Center(child: CircularProgressIndicator(),);
                  }
                  final question = state.questions[state.currentIndex];
                  return Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            CustomBackButton(
                              onPressed: () async {
                                final shouldExit = await showDialog<bool>(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Text(
                                      "Quit quiz",
                                      style: Theme.of(context).textTheme.labelMedium,
                                    ),
                                    content: const Text("Are you sure you want to quit?"),
                                    actions: [
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(false),
                                        child: const Text("No"),
                                      ),
                                      TextButton(
                                        onPressed: () => Navigator.of(context).pop(true),
                                        child: const Text("Yes"),
                                      ),
                                    ],
                                  ),
                                );
                                if (!context.mounted) return;
                                if (shouldExit == true) {
                                  context.pop(); // exit page
                                  // Or SystemNavigator.pop(); // exit the app completely
                                }
                              },
                              painters: SquareButtonPainter(context: context),
                            ),
                            Expanded(
                              child: Center(
                                child: Text(state.quizName ?? "Addition",
                                    style: Theme.of(context).textTheme.headlineMedium),
                              ),
                            ),
                            SizedBox(width: 45.w),
                          ],
                        ),
                        state.questions.isNotEmpty?
                        Text("${state.currentIndex+1} / ${state.questions.length}", style: Theme.of(context).textTheme
                            .headlineMedium):SizedBox(),

                        SizedBox(
                          height: 20.w,
                        ),
                        Expanded(
                          child: Align(
                            alignment: Alignment.center,
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  question.questionText,
                                  style: const TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 20.w,
                                ),
                                // Options at bottom
                                AnimatedSwitcher(
                                  duration: const Duration(milliseconds: 300),
                                  child: GridView.builder(
                                    key: ValueKey(state.currentIndex),
                                    shrinkWrap: true,
                                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: 2, // 2x2 grid
                                      childAspectRatio: 2.5,
                                      crossAxisSpacing: 12,
                                      mainAxisSpacing: 12,
                                    ),
                                    itemCount: question.options.length,
                                    itemBuilder: (context, index) {
                                      final option = question.options[index];
                                      final isSelected = state.selectedOption == option;
                                      final isCorrect = option == question.correctAnswer;

                                      Color bgColor = Colors.blue.shade100;
                                      if (isSelected) {
                                        bgColor = isCorrect ? Colors.green : Colors.red;
                                      }

                                      return GestureDetector(
                                        onTap: () {
                                          cubit.selectOption(option);
                                          if (isCorrect) {
                                            cubit.nextQuestion();
                                          }
                                        },
                                        child: AnimatedContainer(
                                          duration: const Duration(milliseconds: 400),
                                          curve: Curves.easeInOut,
                                          decoration: BoxDecoration(
                                            color: bgColor,
                                            borderRadius: BorderRadius.circular(16),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black.withOpacity(0.1),
                                                blurRadius: 6,
                                                offset: const Offset(2, 4),
                                              ),
                                            ],
                                          ),
                                          alignment: Alignment.center,
                                          child: Text(
                                            option.toString(),
                                            style: const TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.w600,
                                              color: Colors.black,
                                            ),
                                          ),
                                        ),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              );
            });
          }),
        ),
      ),
    );
  }
}
