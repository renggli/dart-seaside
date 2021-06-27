import 'package:seaside/seaside.dart';
import 'package:seaside/src/keys.dart';
import 'package:seaside/src/value_holder.dart';
import 'package:test/test.dart';

void main() {
  group('keys', () {
    test('session', () {
      final seen = <String>{};
      for (var i = 0; i < 100; i++) {
        final key = createSessionKey();
        expect(seen.add(key), isTrue, reason: 'duplicate $key');
      }
    });
    test('continuation', () {
      final seen = <String>{};
      for (var i = 0; i < 100; i++) {
        final key = createContinuationKey();
        expect(seen.add(key), isTrue, reason: 'duplicate $key');
      }
    });
  });
  group('value_holder', () {
    test('initial', () {
      final holder = ValueHolder('foo');
      expect(holder.value, 'foo');
    });
    test('snapshot', () {
      final holder = ValueHolder('foo');
      expect(holder.snapshot(), 'foo');
    });
    test('restore', () {
      final holder = ValueHolder('foo');
      holder.restore('bar');
      expect(holder.value, 'bar');
    });
  });
  group('futures', () {
    test('complete multiple times', () {
      final values = <int>[];
      final completer = ResumableCompleter<int>();
      completer.future.then(values.add);
      completer.complete(1);
      completer.complete(2);
      completer.complete(3);
      expect(values, [1, 2, 3]);
    });
    test('chains multiple times', () {
      final values = <String>[];
      final completer = ResumableCompleter<int>();
      completer.future
          .then((value) => value - 1)
          .then((value) => value.toString())
          .then(values.add);
      completer.complete(1);
      completer.complete(2);
      completer.complete(3);
      expect(values, ['0', '1', '2']);
    });
    test('chains with split', () {
      final values = <String>[];
      final completer = ResumableCompleter<int>();
      completer.future
          .then((value) => value - 1)
          .then((value) => value.toString())
          .then(values.add);
      completer.future
          .then((value) => value + 1)
          .then((value) => value.toString())
          .then(values.add);
      completer.complete(1);
      completer.complete(2);
      completer.complete(3);
      expect(values, ['0', '2', '1', '3', '2', '4']);
    });
  });
}
