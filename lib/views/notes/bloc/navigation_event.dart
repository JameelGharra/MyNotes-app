import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class NavigationEvent {
  const NavigationEvent();
}

class NavigationNoteViewEvent extends NavigationEvent {
  const NavigationNoteViewEvent();
}
