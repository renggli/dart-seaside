import 'package:seaside/seaside.dart';

/// The standard hello world example.
class HelloWorld extends Task {
  @override
  void run() {
    show(InputDialog(title: 'What is your name?', value: 'World'),
        onAnswer: (name) => show(Dialog(title: 'Hello $name!')));
  }
}
