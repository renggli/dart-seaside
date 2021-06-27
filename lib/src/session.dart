import 'package:shelf/shelf.dart';

import 'component.dart';
import 'continuation.dart';
import 'keys.dart';
import 'limiting_map.dart';

/// User session persistent as long as the user is interacting with it.
class Session {
  final String sessionKey;
  final Map<String, Continuation> _continuations = LimitingMap({}, 25);
  final Component component;

  Session(this.sessionKey, this.component);

  /// Handles the creation and resolution of continuations, including the
  /// rendering of the response using the root component.
  Future<Response> call(Request request) async {
    final previousKey = request.requestedUri.queryParameters[continuationParam];
    if (_continuations.containsKey(previousKey)) {
      await _continuations[previousKey]!(request);
    }

    final continuationKey = createContinuationKey();
    final continuation = Continuation(sessionKey, continuationKey, component);
    _continuations[continuationKey] = continuation;
    final headContents = component.withAllChildren
        .map((component) => component.head(continuation))
        .join();
    final bodyContents = component.body(continuation);
    return Response.ok('''
<!DOCTYPE html>
<html>
  <head>$headContents</head>
  <body>$bodyContents</body>
</html>
''', headers: {'Content-Type': 'text/html'});
  }
}
