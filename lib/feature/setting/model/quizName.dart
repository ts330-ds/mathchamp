
// To parse this JSON data, do
//
//     final quizGame = quizGameFromJson(jsonString);

import 'dart:convert';

QuizGame quizGameFromJson(String str) => QuizGame.fromJson(json.decode(str));

String quizGameToJson(QuizGame data) => json.encode(data.toJson());

class QuizGame {
  String? name;
  String? path;

  QuizGame({
    this.name,
    this.path,
  });

  factory QuizGame.fromJson(Map<String, dynamic> json) => QuizGame(
    name: json["name"],
    path: json["path"],
  );

  Map<String, dynamic> toJson() => {
    "name": name,
    "path": path,
  };
}
