import 'dart:isolate';
import 'dart:math';
import 'package:mathchamp/feature/questions/optionGenerator.dart';
import 'model/questionModel.dart';

class QuestionGenerator {
  static final questionTypes = [
    'addition',
    'subtraction',
    'multiplication',
    'division'
  ];

  static Future<List<Question>> generate({
    required int numberOfQuestions,
    required (String, int) range,
    required String gameHeading,
    required int lastDigit,
    required int firstDigit,
  }) async {
    return await Isolate.run(() {
      final random = Random();
      final questions = <Question>[];

      final (minFirst, maxFirst) = _getRange(firstDigit);
      final (minLast, maxLast) = _getRange(lastDigit);

      for (int i = 0; i < numberOfQuestions; i++) {
        String type = questionTypes[random.nextInt(questionTypes.length)];
        final effectiveHeading = gameHeading.toLowerCase() == "mixed"
            ? type
            : gameHeading.toLowerCase();

        int answer;
        String questionText;

        switch (effectiveHeading) {
          case 'addition':
            int a = minFirst + random.nextInt(maxFirst - minFirst + 1);
            int b = (range.$2 > 1) ? 1 + random.nextInt(range.$2 - 1) : 1;
            answer = a + b;
            questionText = "$a + $b = ?";
            break;
          case 'subtraction':
            int a = minFirst + random.nextInt(maxFirst - minFirst + 1);
            int b = (range.$2 > 1) ? 1 + random.nextInt(range.$2 - 1) : 1;
            if (a < b) {
              final temp = a;
              a = b;
              b = temp;
            }
            answer = a - b;
            questionText = "$a - $b = ?";
            break;
          case 'multiplication':
            int a = minFirst + random.nextInt(maxFirst - minFirst + 1);
            int b = (range.$2 > 1) ? 1 + random.nextInt(range.$2 - 1) : 1;
            answer = a * b;
            questionText = "$a × $b = ?";
            break;
          case 'division':
            int b = 1 + random.nextInt(range.$2);
            int kMin = (minLast / b).ceil();
            int kMax = (maxLast / b).floor();
            if (kMax < kMin) kMax = kMin;
            
            int kRange = kMax - kMin + 1;
            int k = kMin + random.nextInt(kRange);
            int a = b * k;
            answer = k;
            questionText = "$a ÷ $b = ?";
            break;
          case 'tables':
            int a = 1 + random.nextInt(maxLast);
            int b = 1 + random.nextInt(range.$2);
            answer = a * b;
            questionText = "$a × $b = ?";
            break;
          case 'square root':
            answer = 1 + random.nextInt(maxLast);
            int a = answer * answer;
            questionText = "√$a = ?";
            break;
          case 'powers':
            int a = 2 + random.nextInt(range.$2);
            int b = firstDigit;
            answer = pow(a, b).toInt();
            questionText = "$a^$b = ?";
            break;
          default:
            int b = 1 + random.nextInt(range.$2);
            int k = minLast + random.nextInt((maxLast ~/ b) - minLast + 1);
            int a = b * k;
            answer = a ~/ b;
            questionText = "$a ÷ $b = ?";
        }

        questions.add(Question(
          questionText: questionText,
          options: generateOptions(answer),
          correctAnswer: answer,
        ));
      }
      return questions;
    });
  }

  static (int, int) _getRange(int digitCount) {
    switch (digitCount) {
      case 1:
        return (1, 9);
      case 2:
        return (11, 99);
      case 3:
        return (101, 999);
      default:
        return (1, 9);
    }
  }
}
