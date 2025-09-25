import 'dart:io';
import 'dart:ui' as ui;
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

void showCongratsDialog(
    BuildContext context, String userName, int time, int firstDigit, int lastDigit, String gameName) {
  final GlobalKey _globalKey = GlobalKey();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (ctx) {
      return PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, result) async {
          if (didPop) return;
          Navigator.of(ctx).pop(true);
          context.pop();
        },
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("🎉 Congratulations!", style: Theme.of(context).textTheme.labelMedium),

              SizedBox(height: 10.w),

              Text(userName, style: Theme.of(context).textTheme.labelMedium?.copyWith(fontSize: 28)),

              SizedBox(height: 10.w),

              // RepaintBoundary widget to capture as image
              Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.w),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(gameName, style: Theme.of(context).textTheme.labelMedium),
                    SizedBox(height: 10.w),
                    Text("$firstDigit*$lastDigit Digits", style: Theme.of(context).textTheme.labelMedium),
                    SizedBox(height: 20.w),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Time Taken: ",
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        Text(
                          "$time seconds",
                          style: Theme.of(context).textTheme.labelMedium,
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10,
                    ),
                    Text("Take Screenshot and share among friends", style: Theme.of(context).textTheme.bodyMedium),
                    SizedBox(
                      height: 10,
                    ),
                    Image.asset("assets/logo.png", width: 120.w, height: 120.w, fit: BoxFit.contain),
                    Text(
                      "MathChamp - Download app now",
                      style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: Theme.of(context).primaryColor),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(true);
                context.pop();
              },
              child: const Text("Close"),
            ),
          ],
        ),
      );
    },
  );
}

String getGameSign(String gameName) {
  switch (gameName) {
    case "Addition":
      return "+";
    case "Subtraction":
      return "-";
    case "Multiplication":
      return "×"; // or '*'
    case "Division":
      return "÷";
    case "Mixed":
      return "+ - × ÷"; // or '/'
    case "Power":
      return "^"; // exponent
    case "Root":
      return "√";
    default:
      return "?"; // fallback if unknown
  }
}
