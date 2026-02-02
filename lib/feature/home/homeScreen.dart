import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailCubit.dart';
import 'package:mathchamp/feature/home/cubit/homeCubit.dart';
import 'package:mathchamp/feature/home/cubit/homeState.dart';
import 'package:mathchamp/feature/home/widget/gameList.dart';
import 'package:mathchamp/feature/home/widget/additionGamesList.dart';
import 'package:mathchamp/feature/home/widget/selectDropdownWidget.dart';
import 'package:mathchamp/feature/setting/cubit/settingCubit.dart';
import 'package:mathchamp/feature/setting/cubit/settingState.dart';
import 'package:mathchamp/utils/custom_theme.dart';

import '../../ads/adsCubit.dart';
import '../../ads/adsState.dart';
import '../../customDesign/waveAppbar.dart';
import '../../main.dart';
import '../setting/model/quizName.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _welcomeController;
  late Animation<double> _welcomeAnimation;

  List<QuizGame> quizGames = [
    QuizGame(name: "Addition", path: "assets/quiz/plus.png", emoji: "+"),
    QuizGame(name: "Subtraction", path: "assets/quiz/minus.png", emoji: "-"),
    QuizGame(name: "Multiplication", path: "assets/quiz/multi.png", emoji: "×"),
    QuizGame(name: "Division", path: "assets/quiz/divide.png", emoji: "÷"),
    QuizGame(name: "Multiplication Tables", path: "assets/quiz/table.png", emoji: "📊"),
    QuizGame(name: "Mixed", path: "assets/quiz/mixed.png", emoji: "🎲"),
    QuizGame(name: "Square Root", path: "assets/quiz/root.png", emoji: "√"),
    QuizGame(name: "Powers", path: "assets/quiz/power.png", emoji: "²"),
  ];

  QuizGame? selectQuiz;

  @override
  void initState() {
    super.initState();
    _welcomeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _welcomeAnimation = CurvedAnimation(
      parent: _welcomeController,
      curve: Curves.elasticOut,
    );
    _welcomeController.forward();
  }

  @override
  void dispose() {
    _welcomeController.dispose();
    super.dispose();
  }

  List<(String, String, Color, int, int, String)> getQuizType(String name) {
    switch (name) {
      case "Addition":
        return GameList.addition_list;
      case "Subtraction":
        return GameList.substraction_list;
      case "Multiplication":
        return GameList.multi_list;
      case "Division":
        return GameList.divison_list;
      case "Powers":
        return GameList.power_list;
      case "Square Root":
        return GameList.root_list;
      case "Multiplication Tables":
        return GameList.table_list;
      case "Mixed":
        return GameList.mixed_list;
      default:
        return GameList.addition_list;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: MultiBlocProvider(
        providers: [
          BlocProvider<HomeCubit>(create: (_) => HomeCubit(prefs)),
        ],
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
            child: Column(
              children: [
                // Custom Kid-Friendly App Bar
                KidsAppBar(),
                // Main Content
                Expanded(
                  child: BlocBuilder<HomeCubit, HomeState>(
                    builder: (context, state) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Welcome Message
                          _buildWelcomeSection(context),
                          // Quiz Type Selector
                          _buildQuizSelector(context, state),
                          // Quiz Cards Grid
                          Expanded(
                            child: AdditionalGameList(
                              list: getQuizType(state.quiz!),
                            ),
                          ),
                          // Banner Ad
                          BlocBuilder<AdCubit, AdsState>(
                            builder: (context, state) {
                              final banner = state.bannerAd;
                              if (banner != null) {
                                return Container(
                                  margin: EdgeInsets.only(bottom: 8.w),
                                  child: SizedBox(
                                    width: banner.size.width.toDouble(),
                                    height: banner.size.height.toDouble(),
                                    child: AdWidget(ad: banner),
                                  ),
                                );
                              }
                              return const SizedBox.shrink();
                            },
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context) {
    return BlocBuilder<SettingsCubit, SettingsState>(
      builder: (context, state) {
        String userName = state.currentUser.isNotEmpty
            ? state.currentUser
            : "Math Champion";
        return AnimatedBuilder(
          animation: _welcomeAnimation,
          builder: (context, child) {
            return Transform.scale(
              scale: _welcomeAnimation.value.clamp(0.0, 1.0),
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
                child: Container(
                  padding: EdgeInsets.all(16.w),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
                    ),
                    borderRadius: BorderRadius.circular(20.w),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF6C63FF).withOpacity(0.3),
                        blurRadius: 15,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(12.w),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(15.w),
                        ),
                        child: Text(
                          '👋',
                          style: TextStyle(fontSize: 28.sp),
                        ),
                      ),
                      SizedBox(width: 12.w),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hello, $userName!',
                              style: GoogleFonts.fredoka(
                                fontSize: 20.sp,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            SizedBox(height: 4.w),
                            Text(
                              "Let's practice math today!",
                              style: GoogleFonts.nunito(
                                fontSize: 14.sp,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Stars or achievements
                      Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.w, vertical: 6.w),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFD93D),
                          borderRadius: BorderRadius.circular(20.w),
                        ),
                        child: Row(
                          children: [
                            Text(
                              '⭐',
                              style: TextStyle(fontSize: 16.sp),
                            ),
                            SizedBox(width: 4.w),
                            Text(
                              'Pro',
                              style: GoogleFonts.fredoka(
                                fontSize: 14.sp,
                                fontWeight: FontWeight.bold,
                                color: const Color(0xFF2D3436),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildQuizSelector(BuildContext context, HomeState state) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 8.w),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Choose Your Challenge',
            style: GoogleFonts.fredoka(
              fontSize: 18.sp,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF2D3436),
            ),
          ),
          SizedBox(height: 8.w),
          CustomQuizDropdown(
            cubit: context.read<HomeCubit>(),
            list: context.read<HomeCubit>().quizGames,
          ),
        ],
      ),
    );
  }
}

// Kid-Friendly App Bar
class KidsAppBar extends StatelessWidget {
  const KidsAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.w),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF8B5CF6)],
        ),
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(30.w),
          bottomRight: Radius.circular(30.w),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF6C63FF).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: SafeArea(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Logo and Title
            Row(
              children: [
                Container(
                  padding: EdgeInsets.all(8.w),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(15.w),
                  ),
                  child: Image.asset(
                    "assets/logo.png",
                    width: 40.w,
                    height: 40.w,
                    fit: BoxFit.contain,
                  ),
                ),
                SizedBox(width: 12.w),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'MathChamp',
                      style: GoogleFonts.fredoka(
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      'For Kids 4-16',
                      style: GoogleFonts.nunito(
                        fontSize: 12.sp,
                        color: Colors.white.withOpacity(0.8),
                      ),
                    ),
                  ],
                ),
              ],
            ),
            // User Selector and Settings
            Row(
              children: [
                // Child Profile Dropdown
                BlocBuilder<SettingsCubit, SettingsState>(
                  builder: (context, state) {
                    if (state.userList.isEmpty) {
                      return const SizedBox();
                    }
                    String selectedUser = state.currentUser;
                    return Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.w),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(20.w),
                      ),
                      child: DropdownButton<String>(
                        dropdownColor: const Color(0xFF6C63FF),
                        underline: const SizedBox(),
                        icon: Icon(
                          Icons.keyboard_arrow_down,
                          color: Colors.white,
                          size: 24.w,
                        ),
                        value: state.userList.contains(selectedUser)
                            ? selectedUser
                            : state.userList.first,
                        items: state.userList
                            .map((user) => DropdownMenuItem(
                                  value: user,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text('👤 ',
                                          style: TextStyle(fontSize: 14.sp)),
                                      Text(
                                        user,
                                        style: GoogleFonts.fredoka(
                                          fontSize: 14.sp,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                ))
                            .toList(),
                        onChanged: (val) {
                          if (val != null) {
                            context.read<SettingsCubit>().setCurrentUser(val);
                          }
                        },
                      ),
                    );
                  },
                ),
                SizedBox(width: 8.w),
                // Settings Button
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, '/settings');
                  },
                  child: Container(
                    padding: EdgeInsets.all(10.w),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      borderRadius: BorderRadius.circular(15.w),
                    ),
                    child: Icon(
                      Icons.settings_rounded,
                      color: Colors.white,
                      size: 24.w,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
