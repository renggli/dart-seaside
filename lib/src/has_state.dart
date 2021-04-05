/// Interface of objects with state.
abstract class HasState<T> {
  /// Creates a new snapshot of type [T].
  T snapshot();

  /// Restores a snapshot of type [T].
  void restore(T snapshot);
}
