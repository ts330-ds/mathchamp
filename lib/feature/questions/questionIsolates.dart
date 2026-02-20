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
            // a uses firstDigit range, b uses lastDigit range
            int a = minFirst + random.nextInt(maxFirst - minFirst + 1);
            int b = minLast + random.nextInt(maxLast - minLast + 1);
            answer = a + b;
            questionText = "$a + $b = ?";
            break;

          case 'subtraction':
            // a uses firstDigit range, b uses lastDigit range
            int a = minFirst + random.nextInt(maxFirst - minFirst + 1);
            int b = minLast + random.nextInt(maxLast - minLast + 1);
            // ensure a >= b so result is non-negative
            if (a < b) {
              final temp = a;
              a = b;
              b = temp;
            }
            answer = a - b;
            questionText = "$a - $b = ?";
            break;

          case 'multiplication':
            // a uses firstDigit range, b uses lastDigit range
            int a = minFirst + random.nextInt(maxFirst - minFirst + 1);
            int b = minLast + random.nextInt(maxLast - minLast + 1);
            answer = a * b;
            questionText = "$a × $b = ?";
            break;

          case 'division':
            // divisor b from lastDigit range, dividend a from firstDigit range
            // build a = b * k so division is always exact
            int b = minLast + random.nextInt(maxLast - minLast + 1);
            if (b == 0) b = 1;
            int kMin = (minFirst / b).ceil();
            int kMax = (maxFirst / b).floor();
            if (kMax < kMin) kMax = kMin;
            int k = kMin + random.nextInt(kMax - kMin + 1);
            int a = b * k;
            answer = k;
            questionText = "$a ÷ $b = ?";
            break;

          case 'tables':
            // a from firstDigit range (the table number), b from lastDigit range (multiplier)
            int a = minFirst + random.nextInt(maxFirst - minFirst + 1);
            int b = minLast + random.nextInt(maxLast - minLast + 1);
            answer = a * b;
            questionText = "$a × $b = ?";
            break;

          case 'square root':
            // answer is a 1-digit number whose square is within lastDigit range
            // maxLast for 2-digit → 99, so max answer = 9 (9²=81); for 1-digit → 9
            int maxAnswer = sqrt(maxLast.toDouble()).floor();
            if (maxAnswer < 1) maxAnswer = 1;
            answer = 1 + random.nextInt(maxAnswer);
            int sqNum = answer * answer;
            questionText = "√$sqNum = ?";
            break;

          case 'powers':
            // base from lastDigit range, exponent = firstDigit (2 = square, 3 = cube)
            int base = minLast + random.nextInt(maxLast - minLast + 1);
            if (base < 2) base = 2;
            int exponent = firstDigit; // 2 → square, 3 → cube
            answer = pow(base, exponent).toInt();
            questionText = "$base^$exponent = ?";
            break;

          default:
            // fallback: simple division using digit ranges
            int b = minLast + random.nextInt(maxLast - minLast + 1);
            if (b == 0) b = 1;
            int kMin = (minFirst / b).ceil();
            int kMax = (maxFirst / b).floor();
            if (kMax < kMin) kMax = kMin;
            int k = kMin + random.nextInt(kMax - kMin + 1);
            int a = b * k;
            answer = k;
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
        return (10, 99);
      case 3:
        return (100, 999);
      default:
        return (1, 9);
    }
  }
}
