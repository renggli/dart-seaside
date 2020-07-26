library seaside.bin.multi_counter;

import 'package:seaside/seaside.dart';

import 'counter.dart';

/// The most simple Seaside application reused.
class MultiCounter extends Component {
  @override
  final List<Component> children = List.generate(5, (index) => Counter());

  @override
  String get head => '<title>Multi-counter</title>';

  @override
  String body(Continuation continuation) =>
      children.map((counter) => counter.body(continuation)).join('<hr>');
}
