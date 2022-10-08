import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class NavigationState {
  const NavigationState();
}

class NavigationStateUninitialized extends NavigationState {
  const NavigationStateUninitialized();
}

class NavigationStateNotesView extends NavigationState {
  const NavigationStateNotesView();
}
