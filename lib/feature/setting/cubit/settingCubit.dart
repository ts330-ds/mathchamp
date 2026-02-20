import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mathchamp/feature/setting/cubit/settingState.dart';
import 'package:mathchamp/feature/setting/model/quizName.dart';
import 'package:mathchamp/services/analyticsService.dart';
import 'package:mathchamp/services/musicPlayerService.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsCubit extends Cubit<SettingsState> {
  final SharedPreferences prefs;



  QuizGame? selectgame;
  SettingsCubit(this.prefs)
      : super(SettingsState(
    userList: prefs.getStringList("names") ?? [],
    backgroundMusic: prefs.getBool("backgroundMusic") ?? true,
    language: prefs.getString("language") ?? "en",
    numberOfQuestions: prefs.getInt("numberOfQuestions") ?? 10,
    currentUser: prefs.getString("currentUser")??"No User"
  )){
    // trackAnalytics: false — startup restore of music state is not a user action
    toggleMusic(state.backgroundMusic, trackAnalytics: false);
  }

  void addUser(String name) {
    final updated = [...state.userList, name];
    prefs.setStringList("names", updated);
    emit(state.copyWith(userList: updated));
  }

  void updateUser(String name,int index) {
    final updatedList = List<String>.from(state.userList);
    updatedList[index] = name;

    prefs.setStringList("userList", updatedList);
    emit(state.copyWith(userList: updatedList));
  }


  void removeUser(int index) {
    final updated = [...state.userList]..removeAt(index);
    prefs.setStringList("names", updated);
    emit(state.copyWith(userList: updated));
  }


  // trackAnalytics: true  → user tapped the toggle (log to Firebase)
  // trackAnalytics: false → called internally on startup (do NOT log)
  void toggleMusic(bool value, {bool trackAnalytics = true}) {
    final newValue = value;
    print("new value is $newValue");
    prefs.setBool("backgroundMusic", newValue);
    emit(state.copyWith(backgroundMusic: newValue));
    newValue ? MusicService.play() : MusicService.stop();
    if (trackAnalytics) {
      AnalyticsService.instance.logMusicToggled(newValue);
    }
  }


  void setLanguage(String lang) {
    prefs.setString("language", lang);
    emit(state.copyWith(language: lang));
  }


  void setQuestions(int count) {
    prefs.setInt("numberOfQuestions", count);
    emit(state.copyWith(numberOfQuestions: count));
    AnalyticsService.instance.logDefaultQuestionsChanged(count);
  }

  void setCurrentUser(String name) {
    prefs.setString("currentUser", name);
    emit(state.copyWith(currentUser: name));
  }
}
