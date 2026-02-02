import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mathchamp/feature/bloc/player_2_state.dart';
import 'package:mathchamp/feature/questions/cubit/questionState.dart';
import 'package:mathchamp/feature/questions/questionIsolates.dart';

import '../questions/model/questionModel.dart';


class Player2Cubit extends Cubit<Player2State> {
  DateTime? _startTime;
  DateTime? _endTime;
  Duration? totalTimeTaken;

  Player2Cubit() : super(Player2State(questions: [],quizName: "Addition", currentIndex: 0,gameCompleted: false,
      player_1_correct_question: 0,player_2_correct_question: 0));

  void clearQuestions(){
    emit(state.copyWith(
        quizName: "",
        questions: [],
        currentIndex: 0,
        startTime: DateTime.now(),
        isLoading: false,
        selectedOptionPlayerOne: 0,
        selectedOptionPlayerTwo: 0,
        gameCompleted: false
    ));
  }
  void generateQuestions(
      {required int numberOfQuestions,
        required (String,int) range,
        required String gameHeading,
        required int firstDigit,
        required int lastDigit// range/difficulty range
      }) async{
    emit(state.copyWith(isLoading: true));
    List<Question> questions = await QuestionGenerator.generate(numberOfQuestions: numberOfQuestions, range: range,
        gameHeading:
        gameHeading, lastDigit: lastDigit,firstDigit: firstDigit);
    _startTime = DateTime.now();
    emit(Player2State(questions: questions, currentIndex: 0, quizName: gameHeading,isLoading: false,startTime: _startTime));
  }

  setLoading(bool isloading){
    emit(state.copyWith(isLoading: isloading));
  }
  void nextQuestion() {
    if (state.currentIndex < state.questions.length - 1) {
      emit(state.copyWith(currentIndex: state.currentIndex + 1));
    }else{
      final endTime = DateTime.now();
      totalTimeTaken = endTime.difference(_startTime!);
      emit(state.copyWith(totalTimeTaken: totalTimeTaken,gameCompleted: true));
    }
  }
  void selectOptionPlayerOne(int option) {
    emit(state.copyWith(selectedOptionPlayerOne: option));
  }
  void selectOptionPlayerTwo(int option) {
    emit(state.copyWith(selectedOptionPlayerTwo: option));
  }

}
