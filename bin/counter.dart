library seaside.bin.counter;

import 'package:seaside/seaside.dart';

/// The most simple Seaside application.
class Counter extends Component implements HasState<int> {
  int counter = 0;

  void decrement() => counter--;

  void increment() => counter++;

  @override
  Iterable<HasState> get states => [this];

  @override
  String body(Continuation continuation) => '<h1>$counter</h1>'
      '<a href="${continuation.actionUrl(decrement)}">--</a>'
      '<a href="${continuation.actionUrl(increment)}">++</a>';

  @override
  void restore(int value) => counter = value;

  @override
  int snapshot() => counter;
}
