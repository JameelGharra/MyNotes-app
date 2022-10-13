import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/notes_service/cloud_note.dart';
import 'package:mynotes/services/cloud/notes_service/cloud_notes_storage.dart';
import 'package:mynotes/services/cloud/user_administration/users_administration_exceptions.dart';

class UsersAdministration {
  static final _shared = UsersAdministration._sharedInstance();
  static const String _administrationUsersDbName = 'users';
  static const String _userIdFieldName = 'user_id';
  static const String _userEmailFieldName = 'email';
  static final usersDbInstance =
      FirebaseFirestore.instance.collection(_administrationUsersDbName);

  UsersAdministration._sharedInstance();
  factory UsersAdministration() => _shared;

  Future<void> createUser(
      {required String userId, required String email}) async {
    try {
      final userQueryDocsResult = await usersDbInstance
          .where(_userIdFieldName, isEqualTo: userId)
          .get()
          .then((value) => value.docs);
      if (userQueryDocsResult.isNotEmpty) throw UserAlreadyExistsException();
      await usersDbInstance.add({
        _userIdFieldName: userId,
        _userEmailFieldName: email,
      });
    } catch (_) {
      throw CouldNotCreateUserException();
    }
  }

  Future<void> mapUserIdsToEmails({
    required List<dynamic> userIdsList,
    required List<String> listToStoreEmails,
  }) async {
    listToStoreEmails.clear();
    for (final userId in userIdsList) {
      final userEmailQueryResult = await usersDbInstance
          .where(_userIdFieldName, isEqualTo: userId)
          .get()
          .then((value) => value.docs);
      if (userEmailQueryResult.isEmpty) throw UserIdNotFoundException();
      listToStoreEmails.add(
          userEmailQueryResult.first.data()[_userEmailFieldName] as String);
    }
  }

  Future<List<CloudNote>> mapNoteIdsToNotes(
      {required List<dynamic> noteIds}) async {
    List<CloudNote> notes = [];
    for (final id in noteIds) {
      notes.add(await NotesStorage().getNoteFromId(noteId: id));
    }
    return notes;
  }
}
