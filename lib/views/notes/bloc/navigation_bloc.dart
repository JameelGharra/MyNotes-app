import 'package:bloc/bloc.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/services/cloud/sharing_service/cloud_sharing_storage.dart';
import 'package:mynotes/services/cloud/sharing_service/shared_notes.dart';
import 'package:mynotes/services/cloud/sharing_service/user_blocks.dart';
import 'package:mynotes/services/cloud/user_administration/user_data.dart';
import 'package:mynotes/views/notes/bloc/navigation_event.dart';
import 'package:mynotes/views/notes/bloc/navigation_state.dart';

class NavigationBloc extends Bloc<NavigationEvent, NavigationState> {
  NavigationBloc() : super(const NavigationStateUninitialized()) {
    on<NavigationEventInitialize>(
      (event, emit) async {
        await SharingStorage()
            .identifyRowForUser(userId: AuthService.firebase().currentUser!.id);
        emit(const NavigationStateNotesView());
      },
    );
    on<NavigationEventNoteView>((event, emit) async {
      emit(const NavigationStateNotesView());
    });
    on<NavigationEventBlockView>(
      (event, emit) async {
        await UserBlocks()
            .cacheUserBlocks(userId: AuthService.firebase().currentUser!.id);
        emit(const NavigationStateBlockView());
      },
    );
    on<NavigationEventSharedView>(
      (event, emit) async {
        await SharedNotes().cacheSharedNotes(userId: event.userId);
        emit(const NavigationStateSharedView());
      },
    );
  }
}
