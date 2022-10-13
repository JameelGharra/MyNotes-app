import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/notes_service/cloud_note.dart';
import 'package:mynotes/services/cloud/sharing_service/sharing_exceptions.dart';
import 'package:mynotes/services/cloud/user_administration/user_data.dart';

class SharedNotes {
  static final _shared = SharedNotes._sharedInstance();
  static const String sharingDbName = 'sharing';
  static const String sharingUserIdFieldName = 'user_id';
  static const String sharingBlockedUsersFieldName = 'blocked_user_ids';
  static const String sharingNoteIdsFieldName = 'shared_note_ids';
  static final _sharingDbInstance =
      FirebaseFirestore.instance.collection(sharingDbName);

  SharedNotes._sharedInstance();
  factory SharedNotes() => _shared;

  Future<void> cacheSharedNotes({required String userId}) async {
    try {
      final sharingDocSnapshot =
          await _sharingDbInstance.doc(UserData().sharingDocumentId).get();
      UserData().sharedNotesIds =
          sharingDocSnapshot.data()![sharingNoteIdsFieldName];
    } on Exception {
      throw CouldNotFetchSharedNotesException();
    }
  }
}
