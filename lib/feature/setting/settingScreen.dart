import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:mathchamp/custom_widget/backButton3D.dart';
import 'package:mathchamp/custom_widget/decorations.dart';
import 'package:mathchamp/custom_widget/toogleButton.dart';
import 'package:mathchamp/feature/setting/cubit/settingCubit.dart';
import 'package:mathchamp/feature/setting/cubit/settingState.dart';
import 'package:mathchamp/feature/setting/widgets/selectQuestionNumber.dart';
import 'package:mathchamp/routes/paths.dart';
import 'package:mathchamp/services/musicPlayerService.dart';

import '../../customPainter/backButtonDesign.dart';

class SettingScreen extends StatelessWidget {
  final String? error;

  const SettingScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    final cubit2 = context.read<SettingsCubit>();
    if(cubit2.state.backgroundMusic){
      MusicService.play();
    }
    Size size = MediaQuery.sizeOf(context);
    return SafeArea(
      child: Scaffold(
        body: Padding(
          padding: EdgeInsets.all(10.w),
          child: BlocBuilder<SettingsCubit,SettingsState>(
            builder: (context,state) {
              final cubit = context.read<SettingsCubit>();
              print("cubit 1 ka ${cubit.hashCode}");
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      CustomBackButton(
                        onPressed: () => context.pop(),
                        painters: SquareButtonPainter(context: context),
                      ),
                      Expanded(
                        child: Center(
                          child: Text("Settings", style: Theme.of(context).textTheme.headlineMedium),
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
                        children: [
                          Container(
                            decoration: ConDecorations.conSimpleDecoration(color: Theme.of(context).colorScheme.surface),
                            padding: EdgeInsets.all(10),
                            width: size.width.w - 10.w,
                            child: Column(
                              spacing: 5.w,
                              children: [
                                settingButtons(
                                    name: "Child Profiles",
                                    context: context,
                                    button: Image.asset(
                                      "assets/child_icon.png",
                                      width: 40.w,
                                      height: 40.w,
                                      fit: BoxFit.cover,
                                    ),
                                  navigate: (){
                                      context.push(Paths.childProfileScreen);
                                  }
                                ),
                                settingButtons(
                                    name: "BackGround Music",
                                    context: context,
                                    button: CustomToggleButton(initialValue: state.backgroundMusic,onChanged: (value){
                                      cubit.toggleMusic(value);
                                    },)
                                ),
                                settingButtons(
                                    name: "Select\nQuestions",
                                    context: context,
                                    button: Flexible(
                                      child: QuestionToggle(selectedValue: state.numberOfQuestions, onChanged: (value){
                                        cubit.setQuestions(value);
                                      }),
                                    )
                                ),
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              );
            }
          ),
        ),
      ),
    );
  }

  Widget settingButtons({required String name, Widget? button, required BuildContext context, VoidCallback? navigate}) {
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
