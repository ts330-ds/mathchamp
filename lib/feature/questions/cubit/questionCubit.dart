import 'dart:async';
import 'dart:math';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mathchamp/feature/questions/cubit/questionState.dart';
import 'package:mathchamp/feature/questions/questionIsolates.dart';
import '../model/questionModel.dart';

class QuestionsCubit extends Cubit<QuestionState> {
  DateTime? _startTime;
  DateTime? _endTime;
  Duration? totalTimeTaken;

  QuestionsCubit() : super(QuestionState(questions: [],quizName: "Addition", currentIndex: 0,gameCompleted: false));

  void clearQuestions(){
    emit(state.copyWith(
        quizName: "",
        questions: [],
        currentIndex: 0,
        startTime: DateTime.now(),
        isLoading: false,
        selectedOption: 0,
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
    emit(QuestionState(questions: questions, currentIndex: 0, quizName: gameHeading,isLoading: false,startTime: _startTime));
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
  void selectOption(int option) {
    emit(state.copyWith(selectedOption: option));
  }
}
