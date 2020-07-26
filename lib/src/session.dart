library seaside.session;

import 'package:shelf/shelf.dart';

import 'component.dart';
import 'continuation.dart';
import 'keys.dart';

/// User session persistent as long as the user is interacting with it.
class Session {
  final String sessionKey;
  final Map<String, Continuation> _continuations = {};
  final Component component;

  Session(this.sessionKey, this.component);

  /// Handles the creation and resolution of continuations, including the
  /// rendering of the response using the root component.
  Response call(Request request) {
    _continuations[request.requestedUri.queryParameters[continuationParam]]
        ?.call(request);
    final continuationKey = createContinuationKey();
    final continuation = Continuation(sessionKey, continuationKey, component);
    _continuations[continuationKey] = continuation;
    final headContents =
        component.withAllChildren.map((component) => component.head).join();
    final bodyContents = component.body(continuation);
    return Response.ok('''
        <html>
          <head>$headContents</head>
          <body>$bodyContents</body>
        </html>
    ''', headers: {'Content-Type': 'text/html'});
  }
}
