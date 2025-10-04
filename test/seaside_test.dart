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
}
