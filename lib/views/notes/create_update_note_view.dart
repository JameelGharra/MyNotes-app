import 'package:flutter/material.dart';
import 'package:mynotes/services/auth/auth_service.dart';
import 'package:mynotes/utilities/dialogs/cannot_share_empty_note_dialog.dart';
//import 'package:mynotes/services/crud/notes_service.dart';
import 'package:mynotes/utilities/generics/get_arguments.dart';
import 'package:mynotes/services/cloud/cloud_note.dart';
import 'package:mynotes/services/cloud/firebase_cloud_storage.dart';
import 'package:share_plus/share_plus.dart';
// import 'package:mynotes/services/cloud/cloud_storage_exceptions.dart';

class CreateUpdateNewNote extends StatefulWidget {
  const CreateUpdateNewNote({super.key});

  @override
  State<CreateUpdateNewNote> createState() => _CreateUpdateNewNoteState();
}

class _CreateUpdateNewNoteState extends State<CreateUpdateNewNote> {
  CloudNote? _note;
  late final FirebaseCloudStorage _notesService;
  late final TextEditingController _textController;

  Future<CloudNote> createOrGetExistingNote(BuildContext context) async {
    final widgetNote = context.getArgument<CloudNote>();
    if (widgetNote != null) {
      // update existing note option
      _note = widgetNote;
      _textController.text = widgetNote.text;
      return widgetNote;
    }
    // creation of a note (taking into account hot-reload)
    if (_note == null) {
      final currentUser = AuthService.firebase().currentUser!;
      _note = await _notesService.createNewNote(ownerUserId: currentUser.id);
    }
    return _note!;
  }

  void _deleteNoteIfTextIsEmpty() {
    if (_textController.text.isEmpty && _note != null) {
      _notesService.deleteNote(documentId: _note!.documentId);
    }
  }

  void _saveNoteIfTextNotEmpty() async {
    final text = _textController.text;
    if (_note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        documentId: _note!.documentId,
        text: text,
      );
    }
  }

  void _textControllerListener() async {
    if (_note == null) return;
    final text = _textController.text;
    await _notesService.updateNote(
      documentId: _note!.documentId,
      text: text,
    );
  }

  void _setupTextControllerListener() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  @override
  void initState() {
    _notesService = FirebaseCloudStorage();
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New note'),
          actions: [
            IconButton(
              onPressed: () async {
                final text = _textController.text;
                if (_note == null || text.isEmpty) {
                  await showCannotShareEmptyNoteDialog(context);
                } else {
                  Share.share(text);
                }
              },
              icon: const Icon(Icons.share),
            ),
          ],
        ),
        body: FutureBuilder(
          future: createOrGetExistingNote(context),
          builder: (context, snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.done:
                {
                  _setupTextControllerListener();
                  return TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: 'Start typing your note'), // for expanding
                  );
                }
              default:
                return const CircularProgressIndicator();
            }
          },
        ));
  }
}
