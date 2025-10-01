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

      int minLast = 1, maxLast = 9;
      int minFirst=1,maxFirst=9;
      if (firstDigit == 1) {
        minFirst = 1;
        maxFirst = 9;
      } else if (firstDigit == 2) {
        minFirst = 11;
        maxFirst= 99;
      } else if (firstDigit == 3) {
        minFirst = 101;
        maxFirst = 999;
      } else {
        minFirst = 1;
        maxFirst = 9;
      }

      if (lastDigit == 1) {
        minLast = 1;
        maxLast = 9;
      } else if (lastDigit == 2) {
        minLast = 11;
        maxLast = 99;
      } else if (lastDigit == 3) {
        minLast = 101;
        maxLast = 999;
      } else {
        minLast = 1;
        maxLast = 9;
      }

      for (int i = 0; i < numberOfQuestions; i++) {
        String type = questionTypes[random.nextInt(questionTypes.length)];
        print("The type is  ${gameHeading} ${firstDigit} ${lastDigit} $range");
        late int answer;
        late String questionText;

        switch (gameHeading.toLowerCase()=="mixed"?type:gameHeading.toLowerCase()) {
          case 'addition':
            int a = minFirst + random.nextInt(maxFirst - minFirst + 1);
            int b = (range.$2 > 1) ? 1 + random.nextInt(range.$2 - 1) : 1;
            answer = a + b;
            questionText = "$a + $b = ?";
            break;
          case 'subtraction':
            int a = minFirst + random.nextInt(maxFirst - minFirst + 1);
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
            int a = minFirst + random.nextInt(maxFirst - minFirst + 1);
            int b = (range.$2 > 1) ? 1 + random.nextInt(range.$2 - 1) : 1;
            answer = a * b;
            questionText = "$a × $b = ?";
            break;
          case 'division':
            if (firstDigit == 1) {
              minLast = 1;
              maxLast = 9;
            } else if (firstDigit == 2) {
              minLast = 11;
              maxLast = 99;
            } else if (firstDigit == 3) {
              minLast = 101;
              maxLast = 999;
            } else {
              minLast = 1;
              maxLast = 9;
            }
            int b = 1 + random.nextInt(range.$2);
            int kMin = (minLast / b).ceil();
            int kMax = (maxLast / b).floor();
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
              minLast = 1;
              maxLast = 9;
            } else if (firstDigit == 2) {
              minLast = 11;
              maxLast = 99;
            } else {
              minLast = 1;
              maxLast = 9;
            }
            int a = 1+random.nextInt(maxLast);           // table number
            int b = 1 + Random().nextInt(range.$2); // 1..12
            answer = a * b;
            questionText = "$a × $b = ?";
            break;

          case 'square root':
            answer = 1+ random.nextInt(maxLast);
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
            int k = minLast + random.nextInt((maxLast ~/ b) - minLast + 1);
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
