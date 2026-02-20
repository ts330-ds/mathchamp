import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:mathchamp/ads/adsCubit.dart';
import 'package:mathchamp/feature/bloc/player_2_cubit.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailCubit.dart';
import 'package:mathchamp/feature/questions/cubit/questionCubit.dart';
import 'package:mathchamp/routes/routerConfig.dart';
import 'package:mathchamp/utils/custom_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'feature/setting/cubit/settingCubit.dart';
import 'firebase_options.dart';
import 'services/notificationService.dart';

late final SharedPreferences prefs;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await MobileAds.instance.initialize();

  // Initialize push notification service (FCM + local notifications)
  await NotificationService.instance.initialize();
  prefs = await SharedPreferences.getInstance();
  if (prefs.getBool("backgroundMusic") == null) {
    print("yaa its nulll");
    prefs.setBool('backgroundMusic', true);
  }
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Make the status bar transparent with light (white) icons
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light, // white icons on Android
    statusBarBrightness: Brightness.dark, // white icons on iOS
    systemNavigationBarColor: Colors.transparent,
    systemNavigationBarIconBrightness: Brightness.light,
  ));

  runApp(ScreenUtilInit(
    designSize: const Size(360, 690),
    minTextAdapt: true,
    splitScreenMode: true, // common mobile baseline
    builder: (context, child) => MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>(create: (_) => SettingsCubit(prefs)),
        BlocProvider<GameDetailCubit>(
            create: (_) => GameDetailCubit([("Easy", 11, true)])),
        BlocProvider<QuestionsCubit>(create: (_) => QuestionsCubit()),
        BlocProvider<Player2Cubit>(create: (_) => Player2Cubit()),
        BlocProvider<AdCubit>(create: (_) => AdCubit()),
      ],
      child: const MyApp(),
    ),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final adCubit = context.read<AdCubit>();
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        // Status bar — always transparent with white icons
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,   // Android
        statusBarBrightness: Brightness.dark,         // iOS
        // Navigation bar — always transparent with white icons
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.light,
      ),
      child: MaterialApp.router(
          title: 'MathChamp',
          theme: MathChampTheme.lightTheme,
          darkTheme: MathChampTheme.lightTheme, // Force light theme even on dark OS
          themeMode: ThemeMode.light,           // Never use dark theme
          debugShowCheckedModeBanner: false,
          routerConfig: RouterConfiguration.router(adCubit)),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
