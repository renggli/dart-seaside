import 'package:meta/meta.dart';

/// Interface of objects with state.
@optionalTypeArgs
abstract class HasState<T> {
  /// Creates a new snapshot of type [T].
  T snapshot();

  /// Restores a snapshot of type [T].
  void restore(T snapshot);
}
