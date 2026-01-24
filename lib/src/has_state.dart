import 'package:meta/meta.dart';

/// Interface of objects with state.
///
/// Objects implementing this interface can be backtracked when the user uses
/// the browser's back button.
///
/// Example:
/// ```dart
/// class Counter extends Component implements HasState<int> {
///   int _count = 0;
///
///   @override
///   int snapshot() => _count;
///
///   @override
///   void restore(int snapshot) => _count = snapshot;
///
///   // ...
/// }
/// ```
@optionalTypeArgs
abstract class HasState<T> {
  /// Creates a new snapshot of type [T].
  T snapshot();

  /// Restores a snapshot of type [T].
  void restore(T snapshot);
}
