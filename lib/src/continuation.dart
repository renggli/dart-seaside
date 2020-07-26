library seaside.continuation;

import 'package:shelf/shelf.dart';

import 'component.dart';
import 'has_state.dart';
import 'keys.dart';

/// Type of an action callback function.
typedef Action = void Function();

/// Part of the flow of pages within a session.
class Continuation {
  final String sessionKey;
  final String continuationKey;
  final Map<HasState, dynamic> snapshots = Map.identity();
  final Map<String, Action> callbacks = {};

  Continuation(this.sessionKey, this.continuationKey, Component component) {
    component.withAllChildren
        .expand((child) => child.states)
        .forEach((state) => snapshots[state] = state.snapshot());
  }

  /// Restores the state and executes the callbacks of the request.
  void call(Request request) {
    final queryParameters = request.requestedUri.queryParameters;
    snapshots.forEach((key, value) => key.restore(value));
    callbacks.keys
        .where(queryParameters.containsKey)
        .forEach((key) => callbacks[key]());
  }

  /// Registers a [callback] and returns the corresponding URL.
  Uri action(Action callback) {
    final actionKey = callbacks.length.toString();
    callbacks[actionKey] = callback;
    return Uri(queryParameters: {
      sessionParam: sessionKey,
      continuationParam: continuationKey,
      actionKey: '',
    });
  }
}
