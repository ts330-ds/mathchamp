// To parse this JSON data, do
//
//     final gameDetailState = gameDetailStateFromJson(jsonString);

import 'dart:convert';


class GameDetailState {
  String? gameHeading;
  int? firstDigit;
  int? lastDigit;
  int? numberOfQuestions;
  List<(String,int,bool)>? difficulty;
  (String,int)? selectedDifficulty;

  GameDetailState({
    this.gameHeading,
    this.firstDigit,
    this.lastDigit,
    this.numberOfQuestions,
    this.difficulty,
    this.selectedDifficulty
  });

  GameDetailState copyWith({
    String? gameHeading,
    int? firstDigit,
    int? lastDigit,
    int? numberOfQuestions,
    List<(String,int,bool)>? difficulty,
    (String,int)? selectedDifficulty
  }) =>
      GameDetailState(
        gameHeading: gameHeading ?? this.gameHeading,
        firstDigit: firstDigit ?? this.firstDigit,
        lastDigit: lastDigit ?? this.lastDigit,
        numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
        difficulty: difficulty ?? this.difficulty,
        selectedDifficulty: selectedDifficulty ?? this.selectedDifficulty
      );

}
