import 'call_answer.dart';
import 'component.dart';
import 'continuation.dart';

/// Simple dialog that shows a title and contents.
class Dialog extends Component with CanAnswer<Never> {
  Dialog({this.title = '', this.message = ''});

  final String title;
  final String message;

  @override
  String body(Continuation continuation) => '<h1>$title</h1><p>$message</p>';
}

// Simple dialog with an ok button.
class AlertDialog extends Component with CanAnswer<void> {
  AlertDialog({this.title = '', this.message = ''});

  final String title;
  final String message;

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
  ConfirmationDialog({this.title = '', this.message = ''});

  final String title;
  final String message;

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
  InputDialog({this.title = '', this.message = '', this.value = ''});

  final String title;
  final String message;
  final String value;

  @override
  String body(Continuation continuation) {
    final id = continuation.callbackKey(answer);
    return '<h1>$title</h1><p>$message</p>'
        '<form action="${continuation.actionUrl()}" method="post">'
        '<input type="text" name="$id" value="$value"><br/>'
        '<input type="submit" value="Ok">'
        '</form>';
  }
}

/// Simple dialog that allows picking an item from a list.
class PickerDialog<T> extends Component with CanAnswer<T> {
  PickerDialog({
    this.title = '',
    this.message = '',
    this.selected,
    this.values = const [],
  });

  final String title;
  final String message;
  final T? selected;
  final List<T> values;

  @override
  String body(Continuation continuation) {
    final buffer = StringBuffer();
    buffer.write('<h1>$title</h1><p>$message</p>');
    buffer.write('<form action="${continuation.actionUrl()}" method="post">');
    final callback = continuation.callbackKey(
      (value) => answer(values[int.parse(value)]),
    );
    for (var i = 0; i < values.length; i++) {
      final value = values[i], id = '$callback-$i';
      buffer.write(
        '<input type="radio" id="$id" name="$callback" '
        'value="$value" ${selected == value ? 'checked' : ''}>',
      );
      buffer.write('<label for="$id">$value</label><br/>');
    }
    buffer.write('<input type="submit" value="Ok">');
    buffer.write('</form>');
    return buffer.toString();
  }
}
