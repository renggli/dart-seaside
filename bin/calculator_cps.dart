import 'package:seaside/seaside.dart';

const List<int> numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9];

/// Computes the sum of two numbers using continuation-passing style.
class CalculatorCps extends Task {
  @override
  void run() {
    show<int>(
      PickerDialog(title: 'First number', values: numbers),
      onAnswer: (a) {
        show<int>(
          PickerDialog(title: 'Second number', values: numbers),
          onAnswer: (b) {
            show(Dialog(title: 'Result', message: '$a + $b = ${a + b}'));
          },
        );
      },
    );
  }
}
