library seaside.bin.number_guessing;

import 'dart:math';

import 'package:seaside/seaside.dart';

/// Computes the sum of two numbers using async/await (no backtracking).
class NumberGuessing extends Task {
  @override
  Future<void> run() async {
    for (;;) {
      final userGuesses = await call(ConfirmationDialog(
          title: 'Number guessing',
          message: 'Would you like to guess a number?'));
      if (userGuesses) {
        await _runUserGuesses();
      } else {
        await _runComputerGuesses();
      }
    }
  }

  Future<void> _runUserGuesses() async {
    final secret = 1 + Random().nextInt(99);
    await call(AlertDialog(
        title: 'User guesses',
        message: 'The computer is thinking of a secret number.'));
    for (;;) {
      final value = int.tryParse(await call(
          InputDialog(title: 'User guesses', message: 'What is your guess?')));
      if (value != null) {
        if (value < secret) {
          await call(AlertDialog(
              title: 'User guesses',
              message: 'The secret number is larger than $value.'));
        } else if (value > secret) {
          await call(AlertDialog(
              title: 'User guesses',
              message: 'The secret number is smaller than $value.'));
        } else {
          await call(AlertDialog(
              title: 'User guesses',
              message: 'Congratulations, you found the secret number.'));
          return;
        }
      }
    }
  }

  Future<void> _runComputerGuesses() async {
    var low = 1;
    var high = 100;
    await call(AlertDialog(
        title: 'Computer guesses',
        message: 'Think of a number between $low and $high.'));
    while (low < high) {
      final guess = (low + high) ~/ 2;
      final lower = await call(ConfirmationDialog(
          title: 'Computer guesses',
          message: 'Is the number lower than $guess?'));
      if (lower) {
        high = guess - 1;
      } else {
        low = guess;
      }
    }
    await call(AlertDialog(
        title: 'Computer guesses', message: 'The number must be $low.'));
  }
}
