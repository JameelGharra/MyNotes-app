import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/sharing_service/sharing_exceptions.dart';
import 'package:mynotes/services/cloud/sharing_service/user_sharing_data.dart';

class UserBlocks {
  static const String sharingDbName = 'sharing';
  static const String sharingUserIdFieldName = 'user_id';
  static const String sharingBlockedUsersFieldName = 'blocked_user_ids';
  static final sharingDbInstance =
      FirebaseFirestore.instance.collection(sharingDbName);
  static late final StreamController<List<String>> _blockedUsersStream;
  static final UserBlocks _shared = UserBlocks._sharedInstance();
  UserBlocks._sharedInstance() {
    _blockedUsersStream = StreamController<List<String>>.broadcast(
      onListen: () {
        _blockedUsersStream.sink.add(UserSharingData().blockedUsers);
      },
    );
  }
  factory UserBlocks() => _shared;

  Future<void> cacheUserBlocks({required String userId}) async {
    try {
      final blockedUsersListQuery = await sharingDbInstance
          .where(
            sharingUserIdFieldName,
            isEqualTo: userId,
          )
          .limit(1)
          .get()
          .then((value) => value.docs);
      UserSharingData().blockedUsers = blockedUsersListQuery.first
          .data()[sharingBlockedUsersFieldName] as List<String>;
      _blockedUsersStream.add(UserSharingData().blockedUsers);
    } catch (_) {
      throw CouldNotFetchBlockedUsers();
    }
  }

  Future<void> _updateBlockUserList() async {
    try {
      await sharingDbInstance.doc(UserSharingData().documentId).update(
          {sharingBlockedUsersFieldName: UserSharingData().blockedUsers});
      _blockedUsersStream.add(UserSharingData().blockedUsers);
    } catch (_) {
      throw CouldNotUpdateBlockListException();
    }
  }

  Future<void> blockUser({required userIdToBlock}) async {
    try {
      UserSharingData().blockedUsers.add(userIdToBlock);
      await _updateBlockUserList();
    } catch (_) {
      throw CouldNotUpdateBlockListException();
    }
  }

  Future<void> unBlockUser({required String userBlockedId}) async {
    try {
      UserSharingData().blockedUsers.remove(userBlockedId);
      await _updateBlockUserList();
    } catch (_) {
      throw CouldNotUnblockUserException();
    }
  }
}
