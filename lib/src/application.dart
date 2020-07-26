library seaside.application;

import 'package:shelf/shelf.dart';

import 'component.dart';
import 'keys.dart';
import 'session.dart';

/// Constructs the root component from the initial request.
typedef ComponentFactory = Component Function(Request initialRequest);

/// The starting point of a Seaside application.
class Application {
  final Map<String, Session> _sessions = {};
  final ComponentFactory _componentFactory;

  Application(this._componentFactory);

  /// Handles the creation and dispatching to sessions.
  Response call(Request request) {
    var sessionKey = request.requestedUri.queryParameters[sessionParam];
    if (!_sessions.containsKey(sessionKey)) {
      _sessions[sessionKey = createSessionKey()] =
          Session(sessionKey, _componentFactory(request));
    }
    return _sessions[sessionKey](request);
  }
}
