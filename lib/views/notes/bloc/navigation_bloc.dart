import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/cloud/sharing_service/user_blocks.dart';
import 'package:mynotes/views/notes/bloc/navigation_event.dart';
import 'package:mynotes/views/notes/bloc/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationStateUninitialized()) {
    on<NavigationEventNoteView>(
      (event, emit) => emit(const NavigationStateNotesView()),
    );
    on<NavigationEventBlockView>(
      (event, emit) async {
        await UserBlocks()
            .cacheUserBlocks(userId: AuthService.firebase().currentUser!.id);
        emit(const NavigationStateBlockView());
      },
    );
  }
}
