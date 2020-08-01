library seaside.bin.server;

import 'package:seaside/seaside.dart';
import 'package:shelf/shelf_io.dart';
import 'package:shelf_router/shelf_router.dart';

import 'calculator_cc.dart';
import 'calculator_cps.dart';
import 'counter.dart';
import 'hello_world.dart';
import 'multi_counter.dart';
import 'number_guessing.dart';
import 'tabbed_counters.dart';

/// Web-server for the example applications.
Future<void> main(List<String> args) async {
  final router = Router();
  router.all('/calculator-cc', Application((request) => CalculatorCc()));
  router.all('/calculator-cps', Application((request) => CalculatorCps()));
  router.all('/counter', Application((request) => Counter()));
  router.all('/hello-world', Application((request) => HelloWorld()));
  router.all('/multi-counter', Application((request) => MultiCounter()));
  router.all('/number-guessing', Application((request) => NumberGuessing()));
  router.all('/tabbed-counter', Application((request) => TabbedCounter()));

  final server = await serve(router.handler, 'localhost', 8080);
  print('Serving at http://${server.address.host}:${server.port}');
}
