

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mathchamp/feature/home/cubit/homeState.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../setting/model/quizName.dart';

class HomeCubit extends Cubit<HomeState>{
  final SharedPreferences prefs;

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

  HomeCubit(this.prefs):super(HomeState(
    quiz: prefs.getString("quiz") ?? "Addition"
  ));

  List<QuizGame> getAllQuiz(){
    return quizGames;
  }

  selectQuiz(QuizGame quiz){
    prefs.setString("quiz", quiz.name??"Addition");
    emit(state.copyWith(quiz: quiz.name??"Addition"));
  }

}