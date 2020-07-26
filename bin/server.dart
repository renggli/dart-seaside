library seaside.bin.server;

import 'package:seaside/seaside.dart';
import 'package:shelf/shelf_io.dart';

import 'tabbed_counters.dart';

/// Starts the multi-counter application.
Future<void> main(List<String> args) async {
  final server =
      await serve(Application((request) => TabbedCounter()), 'localhost', 8080);
  print('Serving at http://${server.address.host}:${server.port}');
}
