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
      throw _unsupportedOperation;

  @override
  Future<T> whenComplete(FutureOr<void> Function() action) =>
      throw _unsupportedOperation;

  @override
  Future<T> timeout(Duration timeLimit, {FutureOr<T> Function()? onTimeout}) =>
      throw _unsupportedOperation;

  @override
  Stream<T> asStream() => throw _unsupportedOperation;

  void _onValue(FutureOr<T>? value) {
    if (value is Future<T>) {
      value.then(_onValue, onError: _onError);
    } else if (value != null) {
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
        if (result != null) {
          listener.result._onValue(result);
        } else {
          listener.result._onError(error, stackTrace);
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
