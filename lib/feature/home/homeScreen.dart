// lib/screens/home_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:mathchamp/feature/home/cubit/homeCubit.dart';
import 'package:mathchamp/feature/home/cubit/homeState.dart';
import 'package:mathchamp/feature/home/gameList.dart';
import 'package:mathchamp/feature/home/widget/additionGames.dart';
import 'package:mathchamp/feature/home/widget/selectDropdownWidget.dart';
import 'package:mathchamp/feature/setting/cubit/settingCubit.dart';
import 'package:mathchamp/feature/setting/cubit/settingState.dart';
import 'package:mathchamp/feature/setting/widgets/selectQuestionNumber.dart';

import '../../customDesign/waveAppbar.dart';
import '../../main.dart';
import '../setting/model/quizName.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  List<QuizGame> quizGames = [
    QuizGame(name: "Addition", path: "assets/quiz/plus.png"),
    QuizGame(name: "Subtraction", path: "assets/quiz/minus.png"),
    QuizGame(name: "Multiplication", path: "assets/quiz/multi.png"),
    QuizGame(name: "Division", path: "assets/quiz/divide.png"),
    QuizGame(name: "Multiplication Tables", path: "assets/quiz/table.png"),
    QuizGame(name: "Mixed", path: "assets/quiz/mixed.png"),
    QuizGame(name: "Square Root", path: "assets/quiz/root.png"),
    QuizGame(name: "Powers", path: "assets/quiz/power.png"),
  ];

  QuizGame? selectQuiz;

  List<(String,String,Color,int,String)> getQuizType(String name){
    switch (name) {
      case "Addition":
        return GameList.addition_list;
      case "Subtraction":
        return GameList.substraction_list;
      case "Multiplication":
        return GameList.multi_list;
      case "Division":
        return GameList.divison_list;
      case "Powers":
        return GameList.power_list;
      case "Square Root":
        return GameList.root_list;
      case "Multiplication Tables":
        return GameList.table_list;
      case "Mixed":
        return GameList.mixed_list;
      default:
        return GameList.addition_list;
    }

  }
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          appBar: DoubleWaveAppBar(
            title: 'MathChamp Home',
            color1: Theme.of(context).primaryColor,
            color2: Theme.of(context).primaryColorLight,
          ),
          //appBar: AppBar(title: const Text("MathChamp Home")),
          body: Column(
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: BlocProvider<HomeCubit>(
                  create: (_)=> HomeCubit(prefs),
                  child: CustomQuizDropdown(
                    onChanged: (value) {
                      setState(() {
                        selectQuiz = value;
                      });
                    },
                  ),
                ),
              ),
              Expanded(
                child: MathExamplesGridPage(
                  list: getQuizType(selectQuiz?.name??"Addition"),
                ),
              ),
            ],
          )),
    );
  }
}
