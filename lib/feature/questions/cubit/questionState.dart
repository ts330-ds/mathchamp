import '../model/questionModel.dart';

class QuestionState {
  final bool isLoading;
  final String quizName;
  final List<Question> questions;
  final int currentIndex;
  final DateTime? startTime;
  final Duration? totalTimeTaken;
  final int? selectedOption;
  final bool? gameCompleted;
  final int correctCount;
  final int wrongCount;

  QuestionState(
      {required this.quizName,
      required this.questions,
      this.currentIndex = 0,
      this.startTime,
      this.totalTimeTaken,
      this.isLoading = false,
      this.selectedOption,
      this.gameCompleted = false,
      this.correctCount = 0,
      this.wrongCount = 0});

  // CopyWith method to update specific fields
  QuestionState copyWith(
      {String? quizName,
      List<Question>? questions,
      int? currentIndex,
      DateTime? startTime,
      Duration? totalTimeTaken,
      bool? isLoading,
      int? selectedOption,
      bool clearSelectedOption = false,
      bool? gameCompleted,
      int? correctCount,
      int? wrongCount}) {
    return QuestionState(
        quizName: quizName ?? this.quizName,
        questions: questions ?? this.questions,
        currentIndex: currentIndex ?? this.currentIndex,
        startTime: startTime ?? this.startTime,
        totalTimeTaken: totalTimeTaken ?? this.totalTimeTaken,
        isLoading: isLoading ?? this.isLoading,
        selectedOption: clearSelectedOption ? null : (selectedOption ?? this.selectedOption),
        gameCompleted: gameCompleted ?? this.gameCompleted,
        correctCount: correctCount ?? this.correctCount,
        wrongCount: wrongCount ?? this.wrongCount);
  }
}
