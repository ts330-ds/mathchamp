import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailCubit.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailState.dart';
import 'package:mathchamp/feature/questions/cubit/questionState.dart';

import '../../ads/adsCubit.dart';
import '../../ads/adsState.dart';
import '../../customPainter/backButtonDesign.dart';
import '../../custom_widget/backButton3D.dart';
import '../../custom_widget/decorations.dart';
import '../../custom_widget/icon_custom_btn.dart';
import '../../routes/paths.dart';
import '../questions/cubit/questionCubit.dart';
import '../setting/widgets/selectQuestionNumber.dart';

class CommonStartGamescreen extends StatelessWidget {
  const CommonStartGamescreen({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.sizeOf(context);
    final cubit = context.read<GameDetailCubit>();

    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(10.w),
          child: BlocBuilder<GameDetailCubit, GameDetailState>(builder: (context, state) {
            final cubit = context.read<GameDetailCubit>();
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    CustomBackButton(
                      onPressed: () {
                        final cubit = context.read<QuestionsCubit>();
                        cubit.setLoading(false);
                        context.pop();
                      },
                      painters: SquareButtonPainter(context: context),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(state.gameHeading!, style: Theme.of(context).textTheme.headlineMedium),
                      ),
                    ),
                    SizedBox(width: 45.w),
                  ],
                ),
                Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      spacing: 10.w,
                      children: [
                        Container(
                          decoration: ConDecorations.conSimpleDecoration(color: Theme.of(context).colorScheme.surface),
                          padding: EdgeInsets.all(10),
                          width: size.width.w - 10.w,
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              commonButtons(
                                  name: "Number of\nQuestions",
                                  context: context,
                                  button: Flexible(
                                    child: QuestionToggle(
                                        selectedValue: state.numberOfQuestions ?? 10,
                                        onChanged: (value) {
                                          cubit.selectNoOfQuestion(value);
                                        }),
                                  )),
                              SizedBox(
                                height: 10.w,
                              ),
                              state.difficulty!.length > 1
                                  ? Text("Select Range",
                                      textAlign: TextAlign.start, style: Theme.of(context).textTheme.labelSmall)
                                  : SizedBox(),
                              buildCheckboxList(state.difficulty!, context),
                            ],
                          ),
                        ),
                        BlocBuilder<QuestionsCubit, QuestionState>(builder: (context, questionstate) {
                          final questionsCubit = context.read<QuestionsCubit>();
                          if (questionstate.isLoading) {
                            return CircularProgressIndicator();
                          }
                          return CustomBackButton(
                            onPressed: () {
                              questionsCubit.generateQuestions(
                                numberOfQuestions: state.numberOfQuestions ?? 10,
                                range: state.selectedDifficulty ?? ("Easy", 10),
                                gameHeading: state.gameHeading ?? 'Addition',
                                firstDigit: state.firstDigit ?? 1,
                                lastDigit: state.lastDigit ?? 1,
                              );
                              context.push(Paths.questionScreen);
                            },
                            painters: SquareButtonPainter(context: context),
                            iconData: Icons.add,
                            btnName: "Start Game",
                          );
                        }),
                      ],
                    ),
                  ),
                ),
                BlocBuilder<AdCubit, AdsState>(
                  builder: (context, state) {
                    if (state.common_bannerAd != null) {
                      return SizedBox(
                        width: state.common_bannerAd!.size.width.toDouble(),
                        height: state.common_bannerAd!.size.height.toDouble(),
                        child: AdWidget(ad: state.common_bannerAd!),
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            );
          }),
        ),
      ),
    );
  }

  Widget buildCheckboxList(List<(String, int, bool)> items, BuildContext context) {
    return Column(
      children: List.generate(items.length, (index) {
        final (label, number, isChecked) = items[index];
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
            color: Colors.blue.shade50,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isChecked ? Colors.blue : Colors.grey.shade300,
              width: 2,
            ),
            boxShadow: [
              if (isChecked)
                BoxShadow(
                  color: Colors.blue.withValues(alpha: 0.3),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
            ],
          ),
          child: CheckboxListTile(
            title: Text(
              "$label 0<$number",
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: isChecked ? Colors.blue.shade900 : Colors.black,
              ),
            ),
            value: isChecked,
            activeColor: Colors.blue,
            checkColor: Colors.white,
            onChanged: (value) {
              context.read<GameDetailCubit>().toggle(index);
            },
          ),
        );
      }),
    );
  }

  Widget commonButtons({required String name, Widget? button, required BuildContext context, VoidCallback? navigate}) {
    return GestureDetector(
      onTap: navigate,
      child: Container(
        height: 70.w,
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(borderRadius: BorderRadius.all(Radius.circular(5)), color: Color(0xFFB1D0EA)),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(name, style: Theme.of(context).textTheme.labelMedium?.copyWith(color: Colors.black)),
            button ?? SizedBox()
          ],
        ),
      ),
    );
  }
}
