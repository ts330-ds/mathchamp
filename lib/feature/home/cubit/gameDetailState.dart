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

  GameDetailState({
    this.gameHeading,
    this.firstDigit,
    this.lastDigit,
    this.numberOfQuestions,
    this.difficulty,
  });

  GameDetailState copyWith({
    String? gameHeading,
    int? firstDigit,
    int? lastDigit,
    int? numberOfQuestions,
    List<(String,int,bool)>? difficulty,
  }) =>
      GameDetailState(
        gameHeading: gameHeading ?? this.gameHeading,
        firstDigit: firstDigit ?? this.firstDigit,
        lastDigit: lastDigit ?? this.lastDigit,
        numberOfQuestions: numberOfQuestions ?? this.numberOfQuestions,
        difficulty: difficulty ?? this.difficulty,
      );

}
