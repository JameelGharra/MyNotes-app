import 'package:flutter/foundation.dart' show immutable;

@immutable
abstract class NavigationEvent {
  const NavigationEvent();
}

class NavigationEventInitialize extends NavigationEvent {
  const NavigationEventInitialize();
}

class NavigationEventNoteView extends NavigationEvent {
  const NavigationEventNoteView();
}

class NavigationEventBlockView extends NavigationEvent {
  const NavigationEventBlockView();
}

class NavigationEventSharedView extends NavigationEvent {
  final String userId;
  const NavigationEventSharedView({required this.userId});
}
