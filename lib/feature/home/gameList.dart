

import 'dart:math';
import 'dart:ui';

abstract class GameList{

  static final List<Color> lightColors = [
    Color(0xFFFFCDD2), // Light Red
    Color(0xFFF8BBD0), // Light Pink
    Color(0xFFE1BEE7), // Light Purple
    Color(0xFFD1C4E9), // Light Deep Purple
    Color(0xFFC5CAE9), // Light Indigo
    Color(0xFFBBDEFB), // Light Blue
    Color(0xFFB2EBF2), // Light Cyan
    Color(0xFFB2DFDB), // Light Teal
    Color(0xFFC8E6C9), // Light Green
    Color(0xFFFFF9C4), // Light Yellow
  ];
  static final Random _random = Random();

  static Color get randomColor =>
      lightColors[_random.nextInt(lightColors.length)];

  static final List<(String,String,Color,int,String)> addition_list = [
    ("1 + 1 Digit", "2 + 3",randomColor,1,"Addition"),
    ("2 + 2 Digits","67 + 13",randomColor,2,"Addition"),
    ("2 + 1 Digits", "23 + 3",randomColor,3,"Addition"),
    ("3 + 2 Digits", "245 + 39",randomColor,4,"Addition"),
    ("3 + 3 Digits", "987 + 233",randomColor,5,"Addition")
  ];
  static final List<(String,String,Color,int,String)> substraction_list = [
    ("1 - 1 Digit", "5 - 2", randomColor, 1, "Subtraction"),
    ("2 - 2 Digits", "45 - 12", randomColor, 2, "Subtraction"),
    ("2 - 1 Digits", "23 - 3",randomColor,3,"Subtraction"),
    ("3 - 3 Digits", "223 - 145", randomColor, 3, "Subtraction"),
    ("3 - 2 Digits", "123 - 45", randomColor, 3, "Subtraction"),
  ];

  static final List<(String,String,Color,int,String)> multi_list = [
    ("1 x 1 Digit", "3 x 4", randomColor, 1, "Multiplication"),
    ("2 x 2 Digits", "12 x 13", randomColor, 2, "Multiplication"),
    ("2 x 1 Digit", "13 x 4", randomColor, 1, "Multiplication"),
    ("2 x 2 Digits", "12 x 13", randomColor, 2, "Multiplication"),
    ("3 x 2 Digits", "112 x 13", randomColor, 2, "Multiplication"),
    ("3 x 3 Digits", "12 x 13", randomColor, 2, "Multiplication"),
  ];
  static final List<(String,String,Color,int,String)> divison_list = [
    ("1 ÷ 1 Digits", "6 ÷ 2", randomColor, 1, "Division"),
    ("2 ÷ 2 Digits", "84 ÷ 12", randomColor, 2, "Division"),
    ("3 ÷ 1 Digits", "224 ÷ 4", randomColor, 2, "Division"),
  ];
  static final List<(String,String,Color,int,String)> table_list = [
    ("1 x 1 Digit", "2 x 3",randomColor,1,"Tables"),
    ("2 x 1 Digits", "23 x 3",randomColor,3,"Tables"),
  ];
  static final List<(String,String,Color,int,String)> root_list = [
    ("2 Digits", "√49", randomColor, 1, "Square Root"),
    ("3 Digits", "√625", randomColor, 2, "Square Root"),
  ];
  static final List<(String,String,Color,int,String)> power_list = [
    ("1 Digit Square", "2²", randomColor, 1, "Powers"),
    ("2 Digits Square", "13²", randomColor, 2, "Powers"),
    ("1 Digit Cube", "7³", randomColor, 2, "Powers"),
    ("2 Digits Cube", "12³", randomColor, 2, "Powers"),
  ];

  static final List<(String,String,Color,int,String)> mixed_list = [
    ("All Mixed","+ x ÷ -", Color(0xFFFFCC80), 1, "Mixed"),
  ];


  // (title, example, color, level, category)
  static final List<(String, String, Color, int, String)> quizDataList = [

    ("5 + 3 - 2", "6", Color(0xFFA5D6A7), 1, "Addition & Subtraction"),
    ("12 + 8 - 5", "15", Color(0xFF9FA8DA), 2, "Addition & Subtraction"),

    ("6 x 2 ÷ 3", "4", Color(0xFFCE93D8), 1, "Multiplication & Division"),
    ("15 ÷ 5 x 2", "6", Color(0xFF80DEEA), 2, "Multiplication & Division"),

    ("7 + 3 x 2", "13", Color(0xFFFFCC80), 1, "Mixed"),
    ("18 ÷ 3 + 4", "10", Color(0xFFB0BEC5), 2, "Mixed"),


    ("2²", "4", Color(0xFFFFAB91), 1, "Powers"),
    ("3³", "27", Color(0xFFB2EBF2), 2, "Powers"),
  ];


}