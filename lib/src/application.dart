import 'dart:async';

import 'package:shelf/shelf.dart';

import 'component.dart';
import 'keys.dart';
import 'limiting_map.dart';
import 'session.dart';

/// Constructs the root component from the initial request.
typedef ComponentFactory = FutureOr<Component> Function(Request initialRequest);

/// The starting point of a Seaside application.
///
/// The [Application] class manages the root component of the application and
/// handles incoming requests by dispatching them to the appropriate session.
///
/// Example:
/// ```dart
/// import 'package:shelf/shelf_io.dart' as shelf_io;
///
/// void main() async {
///   var application = Application((request) => MyRootComponent());
///   var server = await shelf_io.serve(application.call, 'localhost', 8080);
///   print('Serving at http://${server.address.host}:${server.port}');
/// }
/// ```
class Application {
  new(this._componentFactory);

  final Map<String, Session> _sessions = LimitingMap({}, 50);
  final ComponentFactory _componentFactory;

  /// Handles the creation and dispatching to sessions.
  Future<Response> call(Request request) async {
    var sessionKey = request.requestedUri.queryParameters[sessionParam];
    if (!_sessions.containsKey(sessionKey)) {
      _sessions[sessionKey = createSessionKey()] = Session(
        sessionKey,
        await _componentFactory(request),
      );
    }
    return _sessions[sessionKey]!(request);
  }
}
