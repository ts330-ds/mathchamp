import 'dart:math';

List<int> generateOptions(int answer, {int spread = 5}) {
  final random = Random();
  final options = <int>{answer};

  // Spread ke around (answer ± spread)
  while (options.length < 4) {
    int option = answer + random.nextInt(spread * 2 + 1) - spread;

    // Negative avoid karo
    if (option < 0) option = 0;

    options.add(option);
  }

  // Shuffle for randomness
  final optionsList = options.toList()..shuffle();
  return optionsList;
}
