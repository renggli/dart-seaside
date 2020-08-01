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

// Simple dialog with an ok button.
class AlertDialog extends Component with CanAnswer<void> {
  final String title;
  final String message;

  AlertDialog({this.title = '', this.message = ''});

  @override
  String body(Continuation continuation) {
    final callback = continuation.callbackKey((value) => answer(null));
    return '<h1>$title</h1><p>$message</p>'
        '<form action="${continuation.actionUrl()}" method="post">'
        '<input type="submit" name="$callback" value="Ok">'
        '</form>';
  }
}

// Simple dialog with yes and no button.
class ConfirmationDialog extends Component with CanAnswer<bool> {
  final String title;
  final String message;

  ConfirmationDialog({this.title = '', this.message = ''});

  @override
  String body(Continuation continuation) {
    final yesCallback = continuation.callbackKey((value) => answer(true));
    final noCallback = continuation.callbackKey((value) => answer(false));
    return '<h1>$title</h1><p>$message</p>'
        '<form action="${continuation.actionUrl()}" method="post">'
        '<input type="submit" name="$yesCallback" value="Yes"> '
        '<input type="submit" name="$noCallback" value="No">'
        '</form>';
  }
}

// Simple dialog that allows entering a string.
class InputDialog extends Component with CanAnswer<String> {
  final String title;
  final String message;
  final String value;

  InputDialog({this.title = '', this.message = '', this.value = ''});

  @override
  String body(Continuation continuation) {
    final id = continuation.callbackKey(answer);
    return '<h1>$title</h1>'
        '<form action="${continuation.actionUrl()}" method="post">'
        '<label for="$id">$message</label><br/>'
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
