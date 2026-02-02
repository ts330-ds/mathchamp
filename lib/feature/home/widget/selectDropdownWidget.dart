import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathchamp/feature/home/cubit/homeCubit.dart';
import 'package:mathchamp/feature/home/cubit/homeState.dart';
import 'package:mathchamp/utils/custom_theme.dart';
import '../../setting/model/quizName.dart';

class CustomQuizDropdown extends StatelessWidget {
  final void Function(QuizGame selected)? onChanged;
  final HomeCubit cubit;
  final List<QuizGame> list;

  const CustomQuizDropdown({
    Key? key,
    this.onChanged,
    required this.cubit,
    required this.list,
  }) : super(key: key);

  String _getQuizEmoji(String? name) {
    switch (name) {
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

  Color _getQuizColor(int index) {
    return MathChampTheme.quizCardColors[index % MathChampTheme.quizCardColors.length];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
        border: Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3), width: 2),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.1),
            spreadRadius: 2,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: PopupMenuButton<QuizGame>(
        onSelected: (quiz) {
          cubit.selectQuiz(quiz);
          onChanged?.call(quiz);
        },
        position: PopupMenuPosition.under,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.w),
        ),
        color: Colors.white,
        elevation: 8,
        itemBuilder: (context) => list.asMap().entries.map((entry) {
          int index = entry.key;
          QuizGame quiz = entry.value;
          return PopupMenuItem<QuizGame>(
            padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.w),
            value: quiz,
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.w),
              decoration: BoxDecoration(
                color: _getQuizColor(index).withOpacity(0.3),
                borderRadius: BorderRadius.circular(15.w),
              ),
              child: Row(
                children: [
                  // Quiz Icon/Emoji
                  Container(
                    width: 45.w,
                    height: 45.w,
                    decoration: BoxDecoration(
                      color: _getQuizColor(index),
                      borderRadius: BorderRadius.circular(12.w),
                      boxShadow: [
                        BoxShadow(
                          color: _getQuizColor(index).withOpacity(0.5),
                          blurRadius: 8,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: quiz.path != null
                          ? Image.asset(
                              quiz.path!,
                              width: 28.w,
                              height: 28.w,
                              fit: BoxFit.contain,
                            )
                          : Text(
                              _getQuizEmoji(quiz.name),
                              style: TextStyle(fontSize: 22.sp),
                            ),
                    ),
                  ),
                  SizedBox(width: 12.w),
                  // Quiz Name
                  Expanded(
                    child: Text(
                      quiz.name ?? "Unnamed Quiz",
                      style: GoogleFonts.fredoka(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF2D3436),
                      ),
                    ),
                  ),
                  // Arrow icon
                  Icon(
                    Icons.chevron_right_rounded,
                    color: const Color(0xFF6C63FF),
                    size: 24.w,
                  ),
                ],
              ),
            ),
          );
        }).toList(),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Current quiz emoji/icon
            Container(
              width: 40.w,
              height: 40.w,
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
                ),
                borderRadius: BorderRadius.circular(12.w),
              ),
              child: Center(
                child: Text(
                  _getQuizEmoji(cubit.state.quiz),
                  style: GoogleFonts.fredoka(
                    fontSize: 20.sp,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            SizedBox(width: 12.w),
            // Current quiz name
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  cubit.state.quiz ?? "Select a Quiz",
                  style: GoogleFonts.fredoka(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF2D3436),
                  ),
                ),
                Text(
                  'Tap to change',
                  style: GoogleFonts.nunito(
                    fontSize: 12.sp,
                    color: const Color(0xFF636E72),
                  ),
                ),
              ],
            ),
            SizedBox(width: 8.w),
            // Dropdown arrow
            Container(
              padding: EdgeInsets.all(6.w),
              decoration: BoxDecoration(
                color: const Color(0xFFFFD93D),
                borderRadius: BorderRadius.circular(10.w),
              ),
              child: Icon(
                Icons.keyboard_arrow_down_rounded,
                color: const Color(0xFF2D3436),
                size: 24.w,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
