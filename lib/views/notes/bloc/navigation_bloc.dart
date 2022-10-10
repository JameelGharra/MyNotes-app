import 'package:bloc/bloc.dart';
import 'package:mynotes/views/notes/bloc/navigation_event.dart';
import 'package:mynotes/views/notes/bloc/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationStateUninitialized()) {
    on<NavigationEventNoteView>(
      (event, emit) => emit(const NavigationStateNotesView()),
    );
    on<NavigationEventBlockView>(
      (event, emit) {
        emit(const NavigationStateBlockView());
      },
    );
  }
}
