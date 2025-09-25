import 'dart:isolate';
import 'dart:math';
import 'package:mathchamp/feature/questions/optionGenerator.dart';

import 'model/questionModel.dart';

class QuestionGenerator {
  static final questionTypes = [
    'addition', 'subtraction','multiplication','division'
  ];
  static Future<List<Question>> generate(
      {required int numberOfQuestions,
      required (String, int) range,
      required String gameHeading,
      required int lastDigit,
      required int firstDigit}) async {
    return await Isolate.run(() {
      final random = Random();
      final questions = <Question>[];

      int min = 1, max = 9;
      int minA=1,maxA=9;
      if (firstDigit == 1) {
        minA = 1;
        maxA = 9;
      } else if (firstDigit == 2) {
        minA = 11;
        maxA= 99;
      } else if (firstDigit == 3) {
        minA = 101;
        maxA = 999;
      } else {
        minA = 1;
        maxA = 9;
      }

      if (lastDigit == 1) {
        min = 1;
        max = 9;
      } else if (lastDigit == 2) {
        min = 11;
        max = 99;
      } else if (lastDigit == 3) {
        min = 101;
        max = 999;
      } else {
        min = 1;
        max = 9;
      }

      for (int i = 0; i < numberOfQuestions; i++) {
        String type = questionTypes[random.nextInt(questionTypes.length)];
        print("The type is  ${gameHeading} ${firstDigit} ${lastDigit} $range");
        late int answer;
        late String questionText;

        switch (gameHeading.toLowerCase()=="mixed"?type:gameHeading.toLowerCase()) {
          case 'addition':
            int a = minA + random.nextInt(maxA - minA + 1);
            int b = (range.$2 > 1) ? 1 + random.nextInt(range.$2 - 1) : 1;
            answer = a + b;
            questionText = "$a + $b = ?";
            break;
          case 'subtraction':
            int a = minA + random.nextInt(maxA - minA + 1);
            int b = (range.$2 > 1) ? 1 + random.nextInt(range.$2 - 1) : 1;
            if(a<b){
              int temp = a;
              a=b;
              b=temp;
            }
            answer = a - b;
            questionText = "$a - $b = ?";
            break;
          case 'multiplication':
            int a = minA + random.nextInt(maxA - minA + 1);
            int b = (range.$2 > 1) ? 1 + random.nextInt(range.$2 - 1) : 1;
            answer = a * b;
            questionText = "$a × $b = ?";
            break;
          case 'division':
            if (firstDigit == 1) {
              min = 1;
              max = 9;
            } else if (firstDigit == 2) {
              min = 11;
              max = 99;
            } else if (firstDigit == 3) {
              min = 101;
              max = 999;
            } else {
              min = 1;
              max = 9;
            }
            int b = 1 + random.nextInt(range.$2);
            int kMin = (min / b).ceil();
            int kMax = (max / b).floor();
            if (kMax < kMin) {
              kMax = kMin; // fallback to at least 1 value
            }
            int ranges = kMax - kMin + 1;
            int k = kMin + Random().nextInt(ranges); // safe, range >=1
            int a = b * k;
            answer = k;
            questionText = "$a ÷ $b = ?";
            break;
          case 'tables':
            if (firstDigit == 1) {
              min = 1;
              max = 9;
            } else if (firstDigit == 2) {
              min = 11;
              max = 99;
            } else {
              min = 1;
              max = 9;
            }
            int a = 1+random.nextInt(max);           // table number
            int b = 1 + Random().nextInt(range.$2); // 1..12
            answer = a * b;
            questionText = "$a × $b = ?";
            break;

          case 'square root':
            answer = 1+ random.nextInt(max);
            int a = answer * answer;                    // radicand
            questionText = "√$a = ?";
            break;

          case 'powers':

            int a = 2 + random.nextInt(range.$2);      // base
            int b = firstDigit;  // exponent
            answer = pow(a, b).toInt();
            questionText = "$a^$b = ?";
            break;
          default:
            print("i am in default");
            int b = 1 + random.nextInt(range.$2); // avoid 0
            int k = min + random.nextInt((max ~/ b) - min + 1);
            int a = b * k;
            answer = a ~/ b;
            questionText = "$a ÷ $b = ?";
        }

        final optionsList = generateOptions(answer);

        questions.add(Question(
          questionText: questionText,
          options: optionsList,
          correctAnswer: answer,
        ));
      }
      return questions;
    });
  }
}
