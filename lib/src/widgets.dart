library seaside.src.widgets;

import 'call_answer.dart';
import 'component.dart';
import 'continuation.dart';

/// Simple dialog that shows a title and contents.
class Dialog extends Component with CanAnswer<void> {
  final String title;
  final String message;

  Dialog({this.title = '', this.message = ''});

  @override
  String body(Continuation continuation) => '<h1>$title</h1><p>$message</p>';
}

// Simple dialog that allows entering a string.
class InputDialog extends Component with CanAnswer<String> {
  final String title;
  final String label;
  final String value;

  InputDialog({this.title = '', this.label = '', this.value = ''});

  @override
  String body(Continuation continuation) {
    final id = continuation.callbackKey(answer);
    return '<h1>$title</h1>'
        '<form action="${continuation.actionUrl()}" method="post">'
        '<label for="$id">$label</label><br/>'
        '<input type="text" id="$id" name="$id" value="$value"><br/>'
        '<input type="submit" value="Ok">'
        '</form>';
  }
}

/// Simple dialog that allows picking an item from a list.
class PickerDialog<T> extends Component with CanAnswer<T> {
  final String title;
  final List<T> values;

  PickerDialog({this.title = '', this.values = const []});

  @override
  String body(Continuation continuation) {
    final buffer = StringBuffer();
    buffer.write('<h1>$title</h1>');
    buffer.write('<ul>');
    for (final value in values) {
      buffer.write('<li>'
          '<a href="${continuation.actionUrl(() => answer(value))}">$value</a>'
          '</li>');
    }
    buffer.write('</ul>');
    return buffer.toString();
  }
}
