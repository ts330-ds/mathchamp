import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mathchamp/feature/home/cubit/gameDetailState.dart';

class GameDetailCubit extends Cubit<GameDetailState> {
  List<(String, int, bool)> difficylty;

  GameDetailCubit(this.difficylty)
      : super(GameDetailState(gameHeading: 'Addition', firstDigit: 1,lastDigit: 1, numberOfQuestions: 10, difficulty:
  difficylty,selectedDifficulty: ("Easy",20)));

  selectGameFromHome(String name,int firstDigit,int lastDigit) {
    if (lastDigit == 2) {
      List<(String, int, bool)> items = [("Easy", 20, true), ("Medium", 50, false), ("Hard", 99, false)];
      emit(state.copyWith(gameHeading: name, firstDigit: firstDigit,lastDigit: lastDigit, difficulty: items));
      return;
    }
    if (lastDigit == 3) {
      List<(String, int, bool)> items = [("Easy", 200, true), ("Medium", 500, false), ("Hard", 999, false)];
      emit(state.copyWith(gameHeading: name, firstDigit: firstDigit,lastDigit: lastDigit, difficulty: items));
      return;
    }
    emit(state.copyWith(gameHeading: name, firstDigit: firstDigit,lastDigit: lastDigit,difficulty: []));
  }

  selectNoOfQuestion(int numberOfQuestoin) {
    emit(state.copyWith(numberOfQuestions: numberOfQuestoin));
  }

  setDifficulty(List<(String, int, bool)> difficylty) {
    this.difficylty = difficylty;
    emit(state.copyWith(difficulty: difficylty));
  }

  void toggle(int index) {
    /*final newState = [...state.difficulty!];
    final (label, number, isChecked) = newState[index];
    newState[index] = (label, number, !isChecked);
    emit(state.copyWith(difficulty: newState));*/
    final current = state.difficulty ?? [];
    if (index < 0 || index >= current.length) return;

    // Create a new list where all are false
    final newState = [
      for (int i = 0; i < current.length; i++)
        (
          current[i].$1, // label
          current[i].$2, // number
          i == index // only selected index = true
        )
    ];
    emit(state.copyWith(difficulty: newState,selectedDifficulty: (current[index].$1,current[index].$2)));
  }
}
