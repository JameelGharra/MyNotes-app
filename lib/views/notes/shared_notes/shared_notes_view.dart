import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/sharing_service/shared_notes.dart';
import 'package:mynotes/services/cloud/user_administration/user_data.dart';
import 'package:mynotes/services/cloud/user_administration/users_administration.dart';
import 'package:mynotes/views/notes/shared_notes/shared_notes_view_list.dart';

class SharedNotesView extends StatefulWidget {
  const SharedNotesView({super.key});

  @override
  State<SharedNotesView> createState() => _SharedNotesViewState();
}

class _SharedNotesViewState extends State<SharedNotesView> {
  late final SharedNotes _sharedNotesService;
  @override
  void initState() {
    _sharedNotesService = SharedNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Shared Notes',
          ),
        ),
        body: StreamBuilder(
          stream: _sharedNotesService.sharedNoteIdsStreamController.stream,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                case ConnectionState.active:
                  return FutureBuilder(
                    future: UsersAdministration().mapNoteIdsToNotes(
                      noteIds: UserData().sharedNotesIds,
                      listToStoreNotes: UserData().sharedNotes,
                    ),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        return const SharedNotesListView();
                      } else {
                        return const CircularProgressIndicator();
                      }
                    },
                  );
                default:
                  return const CircularProgressIndicator();
              }
            }
            return const CircularProgressIndicator();
          },
        ));
  }
}
