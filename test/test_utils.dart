import 'package:checks/checks.dart';
import 'package:seaside/src/value_holder.dart';

/// Extension on [Subject] of [ValueHolder] providing domain-specific checks.
extension ValueHolderChecks<T> on Subject<ValueHolder<T>> {
  /// Extracts the held value.
  Subject<T> get value => has((h) => h.value, 'value');

  /// Extracts the snapshot value.
  Subject<T> get snapshot => has((h) => h.snapshot(), 'snapshot');
}
