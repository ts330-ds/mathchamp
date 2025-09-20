

import 'package:flutter/material.dart';

abstract class ConDecorations{


  static BoxDecoration conSimpleDecoration({
    double raidus = 10,
    Color color = Colors.blue
}){

    return BoxDecoration(
      borderRadius: BorderRadius.all(
          Radius.circular(raidus)
      ),
      color: color
    );
  }


}