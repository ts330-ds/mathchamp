

import '../questions/model/questionModel.dart';

class Player2State {
  final bool isLoading;
  final String quizName;
  final List<Question> questions;
  final int currentIndex;
  final int player_1_correct_question;
  final int player_2_correct_question;
  final DateTime? startTime;
  final Duration? totalTimeTaken;
  final int? selectedOptionPlayerOne;
  final int? selectedOptionPlayerTwo;
  final bool? gameCompleted; // total quiz time
  // range/difficulty range

  Player2State(
      {required this.quizName,
        required this.questions,
        this.currentIndex = 0,
        this.startTime,
        this.totalTimeTaken,
        this.player_1_correct_question = 0,
        this.player_2_correct_question =0,
        this.isLoading = false,
        this.selectedOptionPlayerOne,
        this.selectedOptionPlayerTwo,
        this.gameCompleted = false});

  // CopyWith method to update specific fields
  Player2State copyWith(
      {String? quizName,
        List<Question>? questions,
        int? currentIndex,
        DateTime? startTime,
        Duration? totalTimeTaken,
        bool? isLoading,
        int? player_1_correct_question,
        int? player_2_correct_question,
        int? selectedOptionPlayerOne,
        int? selectedOptionPlayerTwo,
        bool? gameCompleted}) {
    return Player2State(
        quizName: quizName ?? this.quizName,
        questions: questions ?? this.questions,
        currentIndex: currentIndex ?? this.currentIndex,
        startTime: startTime ?? this.startTime,
        player_1_correct_question: player_1_correct_question?? this.player_1_correct_question,
        player_2_correct_question: player_2_correct_question ?? this.player_2_correct_question,
        totalTimeTaken: totalTimeTaken ?? this.totalTimeTaken,
        isLoading: isLoading ?? this.isLoading,
        selectedOptionPlayerOne: selectedOptionPlayerOne ?? this.selectedOptionPlayerOne,
        selectedOptionPlayerTwo: selectedOptionPlayerTwo ?? this.selectedOptionPlayerTwo,
        gameCompleted: gameCompleted ?? this.gameCompleted);
  }
}
