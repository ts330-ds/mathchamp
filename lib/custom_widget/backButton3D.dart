import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomBackButton extends StatefulWidget {
  final VoidCallback onPressed;
  final CustomPainter painters;
  final IconData iconData;
  String? btnName;

   CustomBackButton({super.key, required this.onPressed, required this.painters,
    this.iconData = Icons.arrow_back, this.btnName});

  @override
  State<CustomBackButton> createState() => _CustomBackButtonState();
}

class _CustomBackButtonState extends State<CustomBackButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (_) => setState(() => _scale = 0.9),
      onTapUp: (_) {
        setState(() => _scale = 1.0);
        widget.onPressed();
      },
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 150),
        curve: Curves.easeOut,
        child: CustomPaint(
          painter: widget.painters,
          child:   widget.btnName!=null?
          SizedBox(
            height: 45.w,
            child: Center(
              child: Text(widget.btnName!,style: Theme.of(context).textTheme.labelMedium!.copyWith(color: Colors.white),)),
          ):SizedBox(
            width: 45.w,
            height: 45.w,
            child: Center(
              child: Icon(widget.iconData, color: Colors.white, size: 28),
            ),
          ),
        ),
      ),
    );
  }
}


