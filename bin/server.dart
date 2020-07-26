library seaside.bin.server;

import 'package:seaside/seaside.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'counter.dart';
import 'multi_counter.dart';
import 'tabbed_counters.dart';

Future<void> main(List<String> args) async {
  final router = Router();
  router.all('/counter', Application((request) => Counter()));
  router.all('/multi-counter', Application((request) => MultiCounter()));
  router.all('/tabbed-counter', Application((request) => TabbedCounter()));

  final server = await serve(router.handler, 'localhost', 8080);
  print('Serving at http://${server.address.host}:${server.port}');
}
