import 'package:checks/checks.dart';
import 'package:seaside/src/keys.dart';
import 'package:seaside/src/limiting_map.dart';
import 'package:seaside/src/value_holder.dart';
import 'package:test/scaffolding.dart';

import 'test_utils.dart';

void main() {
  group('keys', () {
    test('session', () {
      final seen = <String>{};
      for (var i = 0; i < 100; i++) {
        final key = createSessionKey();
        check(because: 'duplicate $key', seen.add(key)).isTrue();
      }
    });
    test('continuation', () {
      final seen = <String>{};
      for (var i = 0; i < 100; i++) {
        final key = createContinuationKey();
        check(because: 'duplicate $key', seen.add(key)).isTrue();
      }
    });
  });

  group('value_holder', () {
    test('initial', () {
      final holder = ValueHolder('foo');
      check(holder).value.equals('foo');
    });
    test('snapshot', () {
      final holder = ValueHolder('foo');
      check(holder).snapshot.equals('foo');
    });
    test('restore', () {
      final holder = ValueHolder('foo');
      holder.restore('bar');
      check(holder).value.equals('bar');
    });
  });

  group('limiting_map', () {
    test('enforces limit on index assignment', () {
      final map = LimitingMap<String, int>(<String, int>{}, 2);
      map['a'] = 1;
      map['b'] = 2;
      check(map.length).equals(2);
      map['c'] = 3;
      check(map.length).equals(2);
      check(map.keys).deepEquals(['b', 'c']);
    });

    test('enforces limit on addAll and addEntries', () {
      final map = LimitingMap<String, int>(<String, int>{}, 2);
      map.addAll({'a': 1, 'b': 2, 'c': 3});
      check(map.length).equals(2);
      check(map.keys).deepEquals(['b', 'c']);

      map.addEntries([const MapEntry('d', 4)]);
      check(map.length).equals(2);
      check(map.keys).deepEquals(['c', 'd']);
    });
  });
}
