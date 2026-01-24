import 'dart:async';

import 'package:meta/meta.dart';

import 'component.dart';
import 'continuation.dart';
import 'has_state.dart';
import 'value_holder.dart';

/// Type of an answer handler.
typedef AnswerHandler<T> = void Function(T value);

/// A component with an answer handler.
///
/// This mixin provides the mechanism for a component to return a value to its
/// caller (the component that showed it).
///
/// Example:
/// ```dart
/// class MyDialog extends Component with CanAnswer<bool> {
///   @override
///   String body(Continuation continuation) {
///     // ...
///     // val url = continuation.actionUrl(() => answer(true));
///     // ...
///   }
/// }
/// ```
@optionalTypeArgs
mixin CanAnswer<T> implements Component {
  /// Currently registered answer handler.
  AnswerHandler<T>? onAnswer;

  /// Answers the provided [value].
  void answer(T value) => onAnswer?.call(value);
}

/// A task defines a sequence of components being shown.
///
/// Tasks allow for a linear description of a workflow, where the execution
/// halts at [call] allowing the user to interact with the called component,
/// and resumes when that component answers.
///
/// Example:
/// ```dart
/// class LoginTask extends Task {
///   @override
///   void run() async {
///     var credentials = await call(LoginDialog());
///     if (isValid(credentials)) {
///        await call(MainApplication(credentials));
///     } else {
///        await call(ErrorDialog('Invalid credentials'));
///     }
///   }
/// }
/// ```
abstract class Task extends Component {
  final ValueHolder<CanAnswer?> _delegate = ValueHolder(null);

  bool get isRunning => _delegate.value != null;

  @override
  @nonVirtual
  Component? get delegate => _delegate.value;

  @override
  @mustCallSuper
  Iterable<HasState> get states => [_delegate];

  @override
  @nonVirtual
  String body(Continuation continuation) => isRunning
      ? delegate!.body(continuation)
      : '<script>document.location.href="${continuation.actionUrl(run)}";</script>';

  /// Defines the workflow as a sequence of calls.
  void run();

  /// Shows the provided [component], evaluates the [onAnswer] callback with
  /// the answer of the component.
  void show<T>(CanAnswer<T> component, {AnswerHandler<T>? onAnswer}) {
    _delegate.value = component;
    component.onAnswer = (value) {
      _delegate.value = null;
      onAnswer?.call(value);
    };
  }

  /// Shows the provided [component] asynchronously, resolves the resulting
  /// [Future] with the answer of the component.
  Future<T> call<T>(CanAnswer<T> component) {
    final completer = Completer<T>.sync();
    show<T>(component, onAnswer: completer.complete);
    return completer.future;
  }
}
