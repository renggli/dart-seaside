import 'package:seaside/seaside.dart';

import 'counter.dart';

/// The most simple Seaside application in tabs.
class TabbedCounter extends Component implements HasState<int> {
  final List<Component> tabs = List.generate(5, (index) => Counter());

  int tabIndex = 0;

  @override
  Iterable<HasState> get states => [this];

  @override
  List<Component> get children => [tabs[tabIndex]];

  @override
  String head(Continuation continuation) => '<title>Tabbed-counter</title>';

  @override
  String body(Continuation continuation) {
    final buffer = StringBuffer();
    buffer.write('<ul>');
    for (var i = 0; i < tabs.length; i++) {
      if (tabIndex == i) {
        buffer.write('<li>Counter $i</li>');
      } else {
        buffer.write('<li>'
            '<a href="${continuation.actionUrl(() => tabIndex = i)}">Counter $i</a>'
            '</li>');
      }
    }
    buffer.write('</ul>');
    buffer.write(tabs[tabIndex].body(continuation));
    return buffer.toString();
  }

  @override
  int snapshot() => tabIndex;

  @override
  void restore(int snapshot) => tabIndex = snapshot;
}
