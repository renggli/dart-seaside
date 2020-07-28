library seaside.bin.calculator_cc;

import 'package:seaside/seaside.dart';

final List<int> numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

/// Computes the sum of two numbers using async/await (no backtracking).
class CalculatorCc extends Task {
  @override
  void run() async {
    final a = await call(Picker(title: 'First number', values: numbers));
    final b = await call(Picker(title: 'Second number', values: numbers));
    await call(Dialog(title: 'Result', message: '$a + $b = ${a + b}'));
  }
}
