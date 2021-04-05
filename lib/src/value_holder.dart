import 'has_state.dart';

/// A holder of a backtrack-able value.
class ValueHolder<T> implements HasState<T> {
  ValueHolder(this.value);

  T value;

  @override
  void restore(T snapshot) => value = snapshot;

  @override
  T snapshot() => value;
}
