import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mathchamp/feature/setting/cubit/settingCubit.dart';
import 'package:mathchamp/feature/setting/cubit/settingState.dart';
import 'package:mathchamp/routes/paths.dart';
import 'package:mathchamp/services/musicPlayerService.dart';

class SettingScreen extends StatelessWidget {
  final String? error;

  const SettingScreen({super.key, this.error});

  @override
  Widget build(BuildContext context) {
    final cubit2 = context.read<SettingsCubit>();
    if (cubit2.state.backgroundMusic) {
      MusicService.play();
    }
    return SafeArea(
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFFF8F9FA),
                Color(0xFFE8F4FD),
              ],
            ),
          ),
          child: Padding(
            padding: EdgeInsets.all(16.w),
            child: BlocBuilder<SettingsCubit, SettingsState>(
              builder: (context, state) {
                final cubit = context.read<SettingsCubit>();
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header
                    _buildHeader(context),
                    SizedBox(height: 24.w),
                    // Settings Cards
                    Expanded(
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            // Child Profiles
                            _buildSettingCard(
                              context: context,
                              icon: '👨‍👩‍👧‍👦',
                              title: 'Child Profiles',
                              subtitle: 'Manage player profiles',
                              trailing: Container(
                                padding: EdgeInsets.all(10.w),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF6C63FF).withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(12.w),
                                ),
                                child: Icon(
                                  Icons.chevron_right_rounded,
                                  color: const Color(0xFF6C63FF),
                                  size: 24.w,
                                ),
                              ),
                              onTap: () => context.push(Paths.childProfileScreen),
                            ),
                            SizedBox(height: 12.w),
                            // Background Music
                            _buildSettingCard(
                              context: context,
                              icon: '🎵',
                              title: 'Background Music',
                              subtitle: state.backgroundMusic ? 'Music is on' : 'Music is off',
                              trailing: _buildToggleSwitch(
                                value: state.backgroundMusic,
                                onChanged: (value) => cubit.toggleMusic(value),
                              ),
                            ),
                            SizedBox(height: 12.w),
                            // Questions Count
                            _buildQuestionsSelector(context, state, cubit),
                            SizedBox(height: 24.w),
                            // App Info
                            _buildAppInfoCard(context),
                          ],
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      children: [
        GestureDetector(
          onTap: () => context.pop(),
          child: Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.w),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Icon(
              Icons.arrow_back_rounded,
              color: const Color(0xFF6C63FF),
              size: 24.w,
            ),
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: Text(
            'Settings',
            style: GoogleFonts.fredoka(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3436),
            ),
          ),
        ),
        Text(
          '⚙️',
          style: TextStyle(fontSize: 32.sp),
        ),
      ],
    );
  }

  Widget _buildSettingCard({
    required BuildContext context,
    required String icon,
    required String title,
    required String subtitle,
    required Widget trailing,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20.w),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 50.w,
              height: 50.w,
              decoration: BoxDecoration(
                color: const Color(0xFFF8F9FA),
                borderRadius: BorderRadius.circular(15.w),
              ),
              child: Center(
                child: Text(
                  icon,
                  style: TextStyle(fontSize: 24.sp),
                ),
              ),
            ),
            SizedBox(width: 16.w),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.fredoka(
                      fontSize: 18.sp,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF2D3436),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.nunito(
                      fontSize: 14.sp,
                      color: const Color(0xFF636E72),
                    ),
                  ),
                ],
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }

  Widget _buildToggleSwitch({
    required bool value,
    required Function(bool) onChanged,
  }) {
    return GestureDetector(
      onTap: () => onChanged(!value),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        width: 60.w,
        height: 32.w,
        decoration: BoxDecoration(
          gradient: value
              ? const LinearGradient(
                  colors: [Color(0xFF6BCB77), Color(0xFF4ECDC4)],
                )
              : null,
          color: value ? null : const Color(0xFFE0E0E0),
          borderRadius: BorderRadius.circular(16.w),
        ),
        child: Stack(
          children: [
            AnimatedPositioned(
              duration: const Duration(milliseconds: 200),
              curve: Curves.easeInOut,
              left: value ? 30.w : 4.w,
              top: 4.w,
              child: Container(
                width: 24.w,
                height: 24.w,
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionsSelector(
      BuildContext context, SettingsState state, SettingsCubit cubit) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 50.w,
                height: 50.w,
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FA),
                  borderRadius: BorderRadius.circular(15.w),
                ),
                child: Center(
                  child: Text(
                    '📝',
                    style: TextStyle(fontSize: 24.sp),
                  ),
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Default Questions',
                      style: GoogleFonts.fredoka(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF2D3436),
                      ),
                    ),
                    Text(
                      'Questions per quiz',
                      style: GoogleFonts.nunito(
                        fontSize: 14.sp,
                        color: const Color(0xFF636E72),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16.w),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [5, 10, 15, 20].map((count) {
              bool isSelected = state.numberOfQuestions == count;
              return GestureDetector(
                onTap: () => cubit.setQuestions(count),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 55.w,
                  height: 55.w,
                  decoration: BoxDecoration(
                    gradient: isSelected
                        ? const LinearGradient(
                            colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
                          )
                        : null,
                    color: isSelected ? null : const Color(0xFFF0F0F0),
                    borderRadius: BorderRadius.circular(14.w),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: const Color(0xFF6C63FF).withOpacity(0.4),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ]
                        : null,
                  ),
                  child: Center(
                    child: Text(
                      '$count',
                      style: GoogleFonts.fredoka(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                        color: isSelected ? Colors.white : const Color(0xFF636E72),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildAppInfoCard(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(20.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.circular(20.w),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(12.w),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.w),
            ),
            child: Image.asset(
              "assets/logo.png",
              width: 40.w,
              height: 40.w,
              fit: BoxFit.contain,
            ),
          ),
          SizedBox(width: 16.w),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'MathChamp',
                  style: GoogleFonts.fredoka(
                    fontSize: 20.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  'For Kids 4-16 Years',
                  style: GoogleFonts.nunito(
                    fontSize: 14.sp,
                    color: Colors.white.withOpacity(0.8),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 6.w),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.2),
              borderRadius: BorderRadius.circular(12.w),
            ),
            child: Text(
              'v1.0',
              style: GoogleFonts.nunito(
                fontSize: 14.sp,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
