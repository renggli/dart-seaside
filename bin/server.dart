library seaside.bin;

import 'package:seaside/seaside.dart';
import 'package:shelf/shelf_io.dart';

import 'multi_counter.dart';

/// Starts the multi-counter application.
Future<void> main(List<String> args) async {
  final server =
      await serve(Application((request) => MultiCounter()), 'localhost', 8080);
  print('Serving at http://${server.address.host}:${server.port}');
}
