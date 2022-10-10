import 'package:flutter/foundation.dart' show immutable;
import 'package:mynotes/constants/routes.dart';

@immutable
abstract class NavigationState {
  final String? stateRoute;
  const NavigationState(this.stateRoute);
}

class NavigationStateUninitialized extends NavigationState {
  const NavigationStateUninitialized() : super(null);
}

class NavigationStateNotesView extends NavigationState {
  const NavigationStateNotesView() : super(null);
}

class NavigationStateBlockView extends NavigationState {
  const NavigationStateBlockView() : super(blockedUsersRoute);
}
