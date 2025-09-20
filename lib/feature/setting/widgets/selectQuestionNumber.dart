import 'package:flutter/material.dart';

class QuestionToggle extends StatefulWidget {
  final int selectedValue;
  final ValueChanged<int> onChanged;

  const QuestionToggle({
    Key? key,
    required this.selectedValue,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<QuestionToggle> createState() => _QuestionToggleState();
}

class _QuestionToggleState extends State<QuestionToggle> {
  final List<int> options = [10, 20, 30];

  @override
  Widget build(BuildContext context) {
    final options = [10, 20, 30];

    return ToggleButtons(
      isSelected: options.map((e) => e == widget.selectedValue).toList(),
      onPressed: (index) => widget.onChanged(options[index]),
      borderRadius: BorderRadius.circular(6),
      borderWidth: 2,
      constraints: const BoxConstraints(minWidth: 50, minHeight: 35),
      fillColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.15),
      selectedColor: Theme.of(context).colorScheme.onPrimary,
      selectedBorderColor: Theme.of(context).colorScheme.primary,
      color: Theme.of(context).colorScheme.primary,
      splashColor: Theme.of(context).colorScheme.primary.withValues(alpha: 0.2),
      children: options
          .map(
            (val) => Text(
              val.toString(),
              style: TextStyle(
                fontSize: 16,
                fontWeight: widget.selectedValue == val
                    ? FontWeight.bold
                    : FontWeight.normal,
              ),
            ),
      )
          .toList(),
    );
  }
}

