import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/sharing_service/sharing_exceptions.dart';
import 'package:mynotes/services/cloud/user_administration/user_data.dart';

class SharingStorage {
  static final SharingStorage _shared = SharingStorage._sharedInstance();
  static const String sharingDbName = 'sharing';
  static const String sharingUserIdFieldName = 'user_id';
  static const String sharingBlockedUsersFieldName = 'blocked_user_ids';
  static const String sharingNoteIdsFieldName = 'shared_note_ids';

  static final _sharingDbInstance =
      FirebaseFirestore.instance.collection(sharingDbName);

  SharingStorage._sharedInstance();
  factory SharingStorage() => _shared;

  Future<void> createSharingForUser({required String userId}) async {
    final querySnapshot = await _sharingDbInstance
        .where(sharingUserIdFieldName, isEqualTo: userId)
        .get();
    if (querySnapshot.docs.isNotEmpty) throw SharingForUserExistsException();
    try {
      await _sharingDbInstance.add({
        sharingUserIdFieldName: userId,
        sharingBlockedUsersFieldName: [],
        sharingNoteIdsFieldName: []
      });
    } catch (_) {
      throw CouldNotCreateSharingForUserException();
    }
  }

  Future<void> identifyRowForUser({required String userId}) async {
    final queryResult = await _sharingDbInstance
        .where(
          sharingUserIdFieldName,
          isEqualTo: userId,
        )
        .limit(1)
        .get()
        .then(
          (value) => value.docs,
        );
    if (queryResult.isEmpty) throw CouldNotFindSharingForUserException();
    UserData().sharingDocumentId = queryResult.first.id;
  }
}
