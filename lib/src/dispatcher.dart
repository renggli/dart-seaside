import 'dart:async';

import 'package:shelf/shelf.dart';

/// Dispatches between different handlers based on path name.
///
/// This class is used to route requests to different handlers based on the first
/// segment of the request URL path.
///
/// Example:
/// ```dart
/// var dispatcher = Dispatcher({
///   'app': (request) => Application(MyComponent()),
///   'api': (request) => ApiHandler(),
/// });
/// ```
class Dispatcher {
  Dispatcher(this.handlers);

  final Map<String, Handler> handlers;

  /// Handles the creation and dispatching to sessions.
  FutureOr<Response> call(Request request) {
    final segment = request.url.pathSegments.isNotEmpty
        ? request.url.pathSegments.first
        : '';
    return handlers.containsKey(segment)
        ? handlers[segment]!(request.change(path: segment))
        : defaultHandler(request);
  }

  // Handles errors or unknown paths.
  Response defaultHandler(Request request) {
    final buffer = StringBuffer();
    buffer.write('<html><body><ul>');
    for (final key in handlers.keys) {
      buffer.write('<li><a href="$key">$key</a></li>');
    }
    buffer.write('</ul></body></html>');
    return Response.ok(
      buffer.toString(),
      headers: {'Content-Type': 'text/html'},
    );
  }
}
