// To parse this JSON data, do
//
//     final homeGame = homeGameFromJson(jsonString);

import 'dart:convert';

HomeState homeGameFromJson(String str) => HomeState.fromJson(json.decode(str));

String homeGameToJson(HomeState data) => json.encode(data.toJson());

class HomeState {
  String? quiz;

  HomeState({
    this.quiz,
  });

  HomeState copyWith({String? quiz}) =>
      HomeState(
        quiz: quiz ?? this.quiz,
      );

  factory HomeState.fromJson(Map<String, dynamic> json) => HomeState(
    quiz: json["quiz"],
  );

  Map<String, dynamic> toJson() => {
    "quiz": quiz,
  };
}
