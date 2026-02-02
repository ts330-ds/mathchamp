import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathchamp/ads/adsCubit.dart';
import 'package:mathchamp/ads/adsState.dart';
import 'package:mathchamp/feature/home/commonStartGameScreen.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailCubit.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailState.dart';
import 'package:mathchamp/routes/paths.dart';
import 'package:mathchamp/utils/custom_theme.dart';

class AdditionalGameList extends StatelessWidget {
  List<(String, String, Color, int, int, String)> list;
  AdditionalGameList({super.key, required this.list});

  String _getDifficultyEmoji(String title) {
    if (title.contains('Easy') || title.contains('1*1')) {
      return '🌟';
    } else if (title.contains('Medium') || title.contains('2*')) {
      return '⭐';
    } else if (title.contains('Hard') || title.contains('3*')) {
      return '🏆';
    }
    return '🎯';
  }

  String _getAgeRecommendation(int firstDigit, int lastDigit) {
    int complexity = firstDigit + lastDigit;
    if (complexity <= 2) {
      return 'Ages 4-6';
    } else if (complexity <= 4) {
      return 'Ages 7-9';
    } else if (complexity <= 6) {
      return 'Ages 10-12';
    }
    return 'Ages 13-16';
  }

  Color _getAgeColor(int firstDigit, int lastDigit) {
    int complexity = firstDigit + lastDigit;
    if (complexity <= 2) {
      return MathChampTheme.ageGroup4to6;
    } else if (complexity <= 4) {
      return MathChampTheme.ageGroup7to9;
    } else if (complexity <= 6) {
      return MathChampTheme.ageGroup10to12;
    }
    return MathChampTheme.ageGroup13to16;
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AdCubit, AdsState>(
      builder: (context, adsState) {
        final adCubit = context.read<AdCubit>();
        return BlocBuilder<GameDetailCubit, GameDetailState>(
          builder: (context, state) {
            final cubit = context.read<GameDetailCubit>();
            return Padding(
              padding: EdgeInsets.symmetric(horizontal: 12.w),
              child: GridView.builder(
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 12.w,
                  mainAxisSpacing: 12.w,
                  childAspectRatio: 0.9,
                ),
                itemCount: list.length,
                itemBuilder: (context, index) {
                  final item = list[index];
                  final title = item.$1;
                  final example = item.$2;
                  final color = MathChampTheme.quizCardColors[
                      index % MathChampTheme.quizCardColors.length];
                  final firstDigit = item.$4;
                  final lastDigit = item.$5;
                  final gameHeading = item.$6;
                  final ageColor = _getAgeColor(firstDigit, lastDigit);

                  return GestureDetector(
                    onTap: () {
                      cubit.selectGameFromHome(
                          gameHeading, firstDigit, lastDigit);

                      if (adCubit.state.interstitialAd != null) {
                        adCubit.showInterstitial(() {
                          context.push(Paths.commonStartGameScreen);
                        });
                      } else {
                        context.push(Paths.commonStartGameScreen);
                      }
                    },
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(24.w),
                        boxShadow: [
                          BoxShadow(
                            color: color.withOpacity(0.4),
                            blurRadius: 15,
                            spreadRadius: 2,
                            offset: const Offset(0, 6),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          // Background decoration
                          Positioned(
                            top: -20.w,
                            right: -20.w,
                            child: Container(
                              width: 80.w,
                              height: 80.w,
                              decoration: BoxDecoration(
                                color: color.withOpacity(0.3),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                          // Main content
                          Padding(
                            padding: EdgeInsets.all(12.w),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Age badge
                                Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 8.w, vertical: 4.w),
                                  decoration: BoxDecoration(
                                    color: ageColor.withOpacity(0.2),
                                    borderRadius: BorderRadius.circular(12.w),
                                    border: Border.all(
                                        color: ageColor.withOpacity(0.5)),
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        _getDifficultyEmoji(title),
                                        style: TextStyle(fontSize: 12.sp),
                                      ),
                                      SizedBox(width: 4.w),
                                      Text(
                                        _getAgeRecommendation(
                                            firstDigit, lastDigit),
                                        style: GoogleFonts.nunito(
                                          fontSize: 10.sp,
                                          fontWeight: FontWeight.bold,
                                          color: ageColor,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 8.w),
                                // Title
                                Text(
                                  title,
                                  style: GoogleFonts.fredoka(
                                    fontSize: 16.sp,
                                    fontWeight: FontWeight.bold,
                                    color: const Color(0xFF2D3436),
                                  ),
                                ),
                                SizedBox(height: 8.w),
                                // Example container
                                Expanded(
                                  child: Container(
                                    width: double.infinity,
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          color.withOpacity(0.8),
                                          color,
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(16.w),
                                      boxShadow: [
                                        BoxShadow(
                                          color: color.withOpacity(0.5),
                                          blurRadius: 10,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Center(
                                      child: Text(
                                        example,
                                        textAlign: TextAlign.center,
                                        style: GoogleFonts.fredoka(
                                          fontSize: 20.sp,
                                          fontWeight: FontWeight.bold,
                                          color: Colors.white,
                                          shadows: [
                                            Shadow(
                                              color:
                                                  Colors.black.withOpacity(0.2),
                                              offset: const Offset(1, 1),
                                              blurRadius: 2,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(height: 8.w),
                                // Play button
                                Center(
                                  child: Container(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 16.w, vertical: 6.w),
                                    decoration: BoxDecoration(
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF6C63FF),
                                          Color(0xFF8B5CF6)
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20.w),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFF6C63FF)
                                              .withOpacity(0.4),
                                          blurRadius: 8,
                                          offset: const Offset(0, 4),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.play_arrow_rounded,
                                          color: Colors.white,
                                          size: 18.w,
                                        ),
                                        SizedBox(width: 4.w),
                                        Text(
                                          'Play',
                                          style: GoogleFonts.fredoka(
                                            fontSize: 14.sp,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white,
                                          ),
                                        ),
                                      ],
                                    ),
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
          },
        );
      },
    );
  }
}
