import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:mathchamp/custom_widget/icon_custom_btn.dart';
import 'package:mathchamp/routes/paths.dart';
import 'dart:math';

import '../customPainter/backgorund_painter.dart';
import '../customPainter/customDesign.dart';
import '../feature/setting/cubit/settingCubit.dart';
import '../feature/setting/cubit/settingState.dart';

class DoubleWaveAppBar extends StatefulWidget implements PreferredSizeWidget {
  final double height;
  final Color color1;
  final Color color2;
  final String title;

  const DoubleWaveAppBar({
    super.key,
    this.height = 150,
    required this.color1,
    required this.color2,
    required this.title,
  });

  @override
  _DoubleWaveAppBarState createState() => _DoubleWaveAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height.w);
}

class _DoubleWaveAppBarState extends State<DoubleWaveAppBar> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat(); // continuous animation
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: widget.height.w,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return CustomPaint(
            painter: DoubleWavePainter(animation: _controller.value, color1: widget.color1, color2: widget.color2),
            child: Container(
              alignment: Alignment.topCenter,
              padding: EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Image.asset(
                    "assets/logo.png",
                    width: 80.w,
                    height: 80.w,
                    fit: BoxFit.fitHeight,
                  ),

                  BlocBuilder<SettingsCubit, SettingsState>(
                      builder: (context, state) {
                        if (state.userList.isEmpty) {
                          return Container(child: Text("User"));
                        }
                        if (state.userList.isNotEmpty) {
                          String selectedUser = state.currentUser;
                          return Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: DropdownButton<String>(
                              dropdownColor: Color(0xFF90CAF9),
                              underline: const SizedBox(), // removes default underline
                              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.white,size: 30,),
                              value: state.userList.contains(selectedUser) ? selectedUser : state.userList.first,
                              items: state.userList
                                  .map((user) => DropdownMenuItem(
                                value: user,
                                child: Text("$user",style: Theme.of(context).textTheme.headlineSmall),
                              )).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  context.read<SettingsCubit>().setCurrentUser(val);
                                }
                              },
                            ),
                          );
                        }
                        return SizedBox();
                      }),
                  IconCustomBtn(
                    path: "assets/icon/setting_icon.svg", size: 50.w,
                    onTap: (){
                      context.push(Paths.settingScreen);
                    },
                  ),
                ],
              )
            ),
          );
        },
      ),
    );
  }
}
