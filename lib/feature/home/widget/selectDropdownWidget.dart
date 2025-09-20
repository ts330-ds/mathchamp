import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mathchamp/feature/home/cubit/homeCubit.dart';
import 'package:mathchamp/feature/home/cubit/homeState.dart';
import '../../setting/model/quizName.dart';


class CustomQuizDropdown extends StatelessWidget {
  final void Function(QuizGame selected)? onChanged;

  const CustomQuizDropdown({Key? key, this.onChanged}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState?>(
      builder: (context, state) {
        final cubit = context.read<HomeCubit>();
        final list = cubit.quizGames;

        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: Colors.grey.shade300, width: 1.4),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.shade200,
                spreadRadius: 2,
                blurRadius: 6,
                offset: const Offset(0, 3),
              ),
            ],
          ),
          child: PopupMenuButton<QuizGame>(
            onSelected: (quiz) {
              cubit.selectQuiz(quiz);
              onChanged?.call(quiz);
            },
            position: PopupMenuPosition.under,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            itemBuilder: (context) => list.map((quiz) {
              return PopupMenuItem<QuizGame>(
                padding: EdgeInsets.zero,
                value: quiz,
                child: Card(
                  elevation: 4,
                  color: Theme.of(context).primaryColorLight,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        if (quiz.path != null)
                          Image.asset(
                            quiz.path!,
                            width: 35,
                            height: 35,
                            fit: BoxFit.fill,
                          ),
                        const SizedBox(width: 10),
                        Text(
                          quiz.name ?? "Unnamed Quiz",
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }).toList(),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  state!.quiz! ?? "Select a Quiz",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Icon(Icons.arrow_drop_down,
                    color: Colors.black87, size: 30),
              ],
            ),
          ),
        );
      },
    );
  }
}
