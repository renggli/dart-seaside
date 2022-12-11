import 'package:collection/collection.dart';

/// A map that limits its items to a specific number of keys.
class LimitingMap<K, V> extends DelegatingMap<K, V> {
  LimitingMap(super.delegate, this._limit);

  final int _limit;

  @override
  void operator []=(K key, V value) {
    super[key] = value;
    _enforceLimit();
  }

  @override
  void addAll(Map<K, V> other) {
    super.addAll(other);
    _enforceLimit();
  }

  @override
  void addEntries(Iterable<MapEntry<K, V>> entries) {
    super.addEntries(entries);
    _enforceLimit();
  }

  void _enforceLimit() {
    while (keys.length > _limit) {
      remove(keys.first);
    }
  }
}
