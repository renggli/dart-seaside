import 'package:meta/meta.dart';

import 'continuation.dart';
import 'has_state.dart';

/// Abstract superclass of persistent presenters.
abstract class Component {
  /// Iterable of direct child components.
  Iterable<Component> get children => [];

  /// Delegate component, or `null` otherwise.
  Component? get delegate => null;

  /// Iterable over this component and its deep children.
  @nonVirtual
  Iterable<Component> get withAllChildren => delegate != null
      ? delegate!.withAllChildren
      : [this].followedBy(children.expand((each) => each.withAllChildren));

  /// Iterable of objects that need backtracking.
  Iterable<HasState> get states => [];

  /// Returns the head contents.
  String head(Continuation continuation) => '';

  /// Returns the rendered contents, including its children.
  String body(Continuation continuation);
}
