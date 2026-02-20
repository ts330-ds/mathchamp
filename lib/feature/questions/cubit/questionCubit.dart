import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mathchamp/feature/questions/cubit/questionState.dart';
import 'package:mathchamp/feature/questions/questionIsolates.dart';
import 'package:mathchamp/services/analyticsService.dart';
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
    emit(QuestionState(
      questions: questions,
      currentIndex: 0,
      quizName: gameHeading,
      isLoading: false,
      startTime: _startTime,
      correctCount: 0,
      wrongCount: 0,
    ));
  }

  setLoading(bool isloading){
    emit(state.copyWith(isLoading: isloading));
  }
  void nextQuestion() {
    if (state.currentIndex < state.questions.length - 1) {
      emit(state.copyWith(
        currentIndex: state.currentIndex + 1,
        clearSelectedOption: true,
      ));
    } else {
      final endTime = DateTime.now();
      totalTimeTaken = endTime.difference(_startTime!);
      // Log quiz completed
      AnalyticsService.instance.logQuizCompleted(
        gameType: state.quizName ?? 'Unknown',
        correctCount: state.correctCount,
        wrongCount: state.wrongCount,
        totalQuestions: state.questions.length,
        timeTakenSeconds: totalTimeTaken?.inSeconds ?? 0,
      );
      emit(state.copyWith(
        totalTimeTaken: totalTimeTaken,
        gameCompleted: true,
        clearSelectedOption: true,
      ));
    }
  }

  void selectOption(int option) {
    final currentQuestion = state.questions[state.currentIndex];
    final isCorrect = option == currentQuestion.correctAnswer;
    AnalyticsService.instance.logAnswerSelected(
      isCorrect: isCorrect,
      gameType: state.quizName ?? 'Unknown',
      questionIndex: state.currentIndex,
    );
    emit(state.copyWith(
      selectedOption: option,
      correctCount: isCorrect ? state.correctCount + 1 : state.correctCount,
      wrongCount: isCorrect ? state.wrongCount : state.wrongCount + 1,
    ));
  }
}
