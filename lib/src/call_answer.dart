library seaside.call_answer;

import 'dart:async';

import 'package:meta/meta.dart';

import 'component.dart';
import 'continuation.dart';
import 'has_state.dart';
import 'value_holder.dart';

/// Type of an answer handler.
typedef AnswerHandler<T> = void Function(T value);

/// A component with an answer handler.
mixin CanAnswer<T> implements Component {
  /// Currently registered answer handler.
  AnswerHandler<T> onAnswer;

  /// Answers the provided [value].
  void answer(T value) => onAnswer?.call(value);
}

/// A task defines a sequence of components being shown.
abstract class Task extends Component {
  final ValueHolder<CanAnswer> _delegate = ValueHolder<CanAnswer>();

  bool get isRunning => _delegate.value != null;

  @override
  @mustCallSuper
  Iterable<HasState> get states => [_delegate];

  @override
  @nonVirtual
  Iterable<Component> get children => isRunning ? [_delegate.value] : [];

  @override
  @nonVirtual
  String body(Continuation continuation) => isRunning
      ? _delegate.value.body(continuation)
      : '<script>document.location.href="${continuation.action(run)}";</script>';

  /// Defines the workflow as a sequence of calls.
  void run();

  /// Shows the provided [component], evaluates the [onAnswer] callback with
  /// the answer of the component.
  void show<T>(CanAnswer<T> component, {AnswerHandler<T> onAnswer}) {
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
