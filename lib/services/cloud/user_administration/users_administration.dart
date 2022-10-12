import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/sharing_service/user_sharing_data.dart';
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

  Future<String> getEmailByUserId({required String userId}) async {
    final emailQueryDocsResult = await usersDbInstance
        .where(_userIdFieldName, isEqualTo: userId)
        .get()
        .then((value) => value.docs);
    if (emailQueryDocsResult.isEmpty) throw UserIdNotFoundException();
    return emailQueryDocsResult.first.data()[_userEmailFieldName] as String;
  }

  Future<void> mapUserIdsToEmails({required List<dynamic> userIdsList}) async {
    List<String> userEmails = [];
    for (final userId in userIdsList) {
      final userEmailQueryResult = await usersDbInstance
          .where(_userIdFieldName, isEqualTo: userId)
          .get()
          .then((value) => value.docs);
      if (userEmailQueryResult.isEmpty) throw UserIdNotFoundException();
      userEmails.add(
          userEmailQueryResult.first.data()[_userEmailFieldName] as String);
    }
    UserSharingData().blockedUserEmails = userEmails;
  }
}
