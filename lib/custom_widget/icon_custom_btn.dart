
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class IconCustomBtn extends StatelessWidget{

  String? path;
  VoidCallback? onTap;
  double? size;

  IconCustomBtn({super.key, required this.path, required this.size,this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap??(){},
      child: SvgPicture.asset(
        path!,
        width: size,
        height: size,
      ),
    );
  }
}