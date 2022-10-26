import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/notes_service/cloud_note.dart';
import 'package:mynotes/services/cloud/notes_service/cloud_storage_constants.dart';
import 'package:mynotes/services/cloud/notes_service/cloud_storage_exceptions.dart';

class NotesStorage {
  final notes = FirebaseFirestore.instance.collection('notes');
  static final NotesStorage _shared = NotesStorage._sharedInstance();
  NotesStorage._sharedInstance();
  factory NotesStorage() => _shared;

  Future<CloudNote> createNewNote({required String ownerUserId}) async {
    DateTime currentUtcTime = DateTime.now().toUtc();
    final document = await notes.add({
      ownerUserIdFieldName: ownerUserId,
      textFieldName: '',
      timeFieldName: Timestamp.fromDate(currentUtcTime),
      isFavouredFieldName: false,
    });
    final fetchedNote = await document.get();
    return CloudNote(
      documentId: fetchedNote.id,
      ownerUserId: ownerUserId,
      text: '',
      timeUtc: currentUtcTime,
      isFavoured: false,
    );
  }

  Stream<List<CloudNote>> allNotes({required String ownerUserId}) {
    final allNotes = notes
        .where(ownerUserIdFieldName, isEqualTo: ownerUserId)
        .snapshots()
        .map((event) =>
            event.docs.map((doc) => CloudNote.fromSnapShot(doc)).toList());
    return allNotes;
  }

  Future<void> updateNote({
    required String documentId,
    required String text,
  }) async {
    try {
      await notes.doc(documentId).update({
        textFieldName: text,
        timeFieldName: Timestamp.fromDate(DateTime.now()),
      });
    } catch (_) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> switchFavoured({required CloudNote note}) async {
    try {
      await notes
          .doc(note.documentId)
          .update({isFavouredFieldName: !note.isFavoured});
      note.isFavoured = !note.isFavoured;
    } catch (_) {
      throw CouldNotUpdateNoteException();
    }
  }

  Future<void> deleteNote({required String documentId}) async {
    try {
      await notes.doc(documentId).delete();
    } catch (_) {
      throw CouldNotDeleteNoteException();
    }
  }

  Future<CloudNote> getNoteFromId({required dynamic noteId}) async {
    final noteDocSnapshot = await notes.doc(noteId).get();
    return CloudNote.fromSnapShot(noteDocSnapshot);
  }
}
