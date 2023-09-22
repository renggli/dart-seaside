import 'dart:async';

import 'package:shelf/shelf.dart';

import 'component.dart';
import 'keys.dart';
import 'limiting_map.dart';
import 'session.dart';

/// Constructs the root component from the initial request.
typedef ComponentFactory = FutureOr<Component> Function(Request initialRequest);

/// The starting point of a Seaside application.
class Application {
  Application(this._componentFactory);

  final Map<String, Session> _sessions = LimitingMap({}, 50);
  final ComponentFactory _componentFactory;

  /// Handles the creation and dispatching to sessions.
  Future<Response> call(Request request) async {
    var sessionKey = request.requestedUri.queryParameters[sessionParam];
    if (!_sessions.containsKey(sessionKey)) {
      _sessions[sessionKey = createSessionKey()] =
          Session(sessionKey, await _componentFactory(request));
    }
    return _sessions[sessionKey]!(request);
  }
}
