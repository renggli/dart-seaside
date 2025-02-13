// ignore_for_file: implicit_call_tearoffs

import 'dart:io';

import 'package:seaside/seaside.dart';
import 'package:shelf/shelf_io.dart';

import 'calculator_cc.dart';
import 'calculator_cps.dart';
import 'counter.dart';
import 'hello_world.dart';
import 'multi_counter.dart';
import 'number_guessing.dart';
import 'tabbed_counters.dart';

/// Web-server for the example applications.
Future<void> main(List<String> args) async {
  final server = await serve(
    Dispatcher({
      'calculator-cc': Application((request) => CalculatorCc()),
      'calculator-cps': Application((request) => CalculatorCps()),
      'counter': Application((request) => Counter()),
      'hello-world': Application((request) => HelloWorld()),
      'multi-counter': Application((request) => MultiCounter()),
      'number-guessing': Application((request) => NumberGuessing()),
      'tabbed-counter': Application((request) => TabbedCounter()),
    }),
    'localhost',
    8080,
  );
  stdout.writeln('Serving at http://${server.address.host}:${server.port}');
}
