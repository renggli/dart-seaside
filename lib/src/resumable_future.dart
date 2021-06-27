// ignore_for_file: avoid_dynamic_calls

import 'dart:async';

class ResumableFuture<T> implements Future<T> {
  final List<ResumableListener> listeners = [];

  @override
  Future<R> then<R>(FutureOr<R> Function(T value) onValue,
      {Function? onError}) {
    final result = ResumableFuture<R>();
    listeners.add(ResumableListener<T, R>(result, onValue, onError));
    return result;
  }

  @override
  Future<T> catchError(Function onError, {bool Function(Object error)? test}) =>
      then<T>(
        (value) => value,
        onError: (error, stackTrace) =>
            test == null || test(error) ? onError(error, stackTrace) : null,
      );

  @override
  Future<T> whenComplete(FutureOr<void> Function() action) => then<T>(
        (value) {
          action();
          return value;
        },
        onError: (error) {
          action();
          return null;
        },
      );

  @override
  Future<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout}) =>
      throw _unsupportedOperation;

  @override
  Stream<T> asStream() => throw _unsupportedOperation;

  void _onValue(FutureOr<T>? value) {
    if (value is Future<T>) {
      value.then(_onValue, onError: _onError);
    } else {
      for (final listener in listeners) {
        final callback = listener.callback;
        if (callback != null) {
          listener.result._onValue(callback(value));
        }
      }
    }
  }

  void _onError(Object error, StackTrace? stackTrace) {
    for (final listener in listeners) {
      final callback = listener.errorCallback;
      if (callback != null) {
        final result = callback(error, stackTrace);
        if (result is Future<T>) {
          result.then(_onValue, onError: _onError);
        } else if (result == null) {
          listener.result._onError(error, stackTrace);
        } else {
          listener.result._onValue(result);
        }
      }
    }
  }
}

class ResumableListener<T, R> {
  final ResumableFuture<R> result;

  final Function? callback;

  final Function? errorCallback;

  ResumableListener(this.result, this.callback, this.errorCallback);
}

class ResumableCompleter<T> implements Completer<T> {
  final ResumableFuture<T> _future = ResumableFuture<T>();

  @override
  void complete([FutureOr<T>? value]) => _future._onValue(value);

  @override
  void completeError(Object error, [StackTrace? stackTrace]) =>
      _future._onError(error, stackTrace);

  @override
  Future<T> get future => _future;

  @override
  bool get isCompleted => false;
}

final _unsupportedOperation = UnsupportedError('Unsupported operation.');
