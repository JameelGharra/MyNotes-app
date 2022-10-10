import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class NavigationEvent {
  const NavigationEvent();
}

class NavigationEventNoteView extends NavigationEvent {
  const NavigationEventNoteView();
}

class NavigationEventBlockView extends NavigationEvent {
  const NavigationEventBlockView();
}
