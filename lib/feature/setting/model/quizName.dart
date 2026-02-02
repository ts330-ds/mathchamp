import 'dart:convert';

QuizGame quizGameFromJson(String str) => QuizGame.fromJson(json.decode(str));

String quizGameToJson(QuizGame data) => json.encode(data.toJson());

class QuizGame {
  String? name;
  String? path;
  String? emoji;
  String? description;

  QuizGame({
    this.name,
    this.path,
    this.emoji,
    this.description,
  });

  factory QuizGame.fromJson(Map<String, dynamic> json) => QuizGame(
        name: json["name"],
        path: json["path"],
        emoji: json["emoji"],
        description: json["description"],
      );

  Map<String, dynamic> toJson() => {
        "name": name,
        "path": path,
        "emoji": emoji,
        "description": description,
      };
}
