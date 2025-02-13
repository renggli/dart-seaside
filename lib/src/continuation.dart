import 'dart:convert';

import 'package:shelf/shelf.dart';

import 'component.dart';
import 'has_state.dart';
import 'keys.dart';

/// Callback for actions.
typedef ActionCallback = void Function();

/// Callback for values.
typedef ValueCallback = void Function(String value);

/// Part of the flow of pages within a session.
class Continuation {
  Continuation(this.sessionKey, this.continuationKey, Component component) {
    component.withAllChildren
        .expand((child) => child.states)
        .forEach((state) => snapshots[state] = state.snapshot());
  }

  final String sessionKey;
  final String continuationKey;
  final Map<HasState, dynamic> snapshots = Map.identity();
  final Map<String, ValueCallback> callbacks = {};

  /// Restores the state and executes the callbacks of the request.
  Future<void> call(Request request) async {
    snapshots.forEach((key, value) => key.restore(value));
    final params = await extractParams(request);
    callbacks.keys
        .where(params.containsKey)
        .forEach((key) => callbacks[key]!(params[key]!));
  }

  /// Registers a [callback] and returns the corresponding key.
  String callbackKey(ValueCallback callback) {
    final actionKey = callbacks.length.toString();
    callbacks[actionKey] = callback;
    return actionKey;
  }

  /// Registers a [callback] and returns the corresponding URL.
  Uri actionUrl([ActionCallback? callback]) => Uri(
    queryParameters: {
      sessionParam: sessionKey,
      continuationParam: continuationKey,
      if (callback != null) callbackKey((value) => callback()): '',
    },
  );
}

/// Creates a combined map of GET and POST request params.
Future<Map<String, String>> extractParams(Request request) async {
  final params = Map.of(request.requestedUri.queryParameters);
  if (request.method == 'POST') {
    final body = await request.readAsString();
    if (request.mimeType == 'application/x-www-form-urlencoded') {
      try {
        params.addAll(Uri.splitQueryString(body));
      } on FormatException {
        params.addAll(Uri.splitQueryString(body, encoding: latin1));
      }
    }
    // TODO(renggli): Handle other post mime-types.
  }
  return params;
}
