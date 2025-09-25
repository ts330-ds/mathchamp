import '../model/questionModel.dart';

class QuestionState {
  final bool isLoading;
  final String quizName;
  final List<Question> questions;
  final int currentIndex;
  final DateTime? startTime;
  final Duration? totalTimeTaken;
  final int? selectedOption;
  final bool? gameCompleted; // total quiz time
  // range/difficulty range

  QuestionState(
      {required this.quizName,
      required this.questions,
      this.currentIndex = 0,
      this.startTime,
      this.totalTimeTaken,
      this.isLoading = false,
      this.selectedOption,
      this.gameCompleted = false});

  // CopyWith method to update specific fields
  QuestionState copyWith(
      {String? quizName,
      List<Question>? questions,
      int? currentIndex,
      DateTime? startTime,
      Duration? totalTimeTaken,
      bool? isLoading,
      int? selectedOption,
      bool? gameCompleted}) {
    return QuestionState(
        quizName: quizName ?? this.quizName,
        questions: questions ?? this.questions,
        currentIndex: currentIndex ?? this.currentIndex,
        startTime: startTime ?? this.startTime,
        totalTimeTaken: totalTimeTaken ?? this.totalTimeTaken,
        isLoading: isLoading ?? this.isLoading,
        selectedOption: selectedOption ?? this.selectedOption,
        gameCompleted: gameCompleted ?? this.gameCompleted);
  }
}
