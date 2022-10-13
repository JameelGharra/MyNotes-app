import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mynotes/services/cloud/sharing_service/sharing_exceptions.dart';
import 'package:mynotes/services/cloud/user_administration/user_data.dart';

class UserBlocks {
  static const String sharingDbName = 'sharing';
  static const String sharingUserIdFieldName = 'user_id';
  static const String sharingBlockedUsersFieldName = 'blocked_user_ids';
  static final sharingDbInstance =
      FirebaseFirestore.instance.collection(sharingDbName);
  late final StreamController<List<dynamic>> blockedUsersStream;
  static final UserBlocks _shared = UserBlocks._sharedInstance();
  UserBlocks._sharedInstance() {
    blockedUsersStream = StreamController<List<dynamic>>.broadcast(
      onListen: () {
        blockedUsersStream.sink.add(UserData().blockedUserIds);
      },
    );
  }
  factory UserBlocks() => _shared;

  Future<void> cacheUserBlocks({required String userId}) async {
    try {
      final readDocForUser =
          await sharingDbInstance.doc(UserData().sharingDocumentId).get();
      UserData().blockedUserIds =
          readDocForUser.data()![sharingBlockedUsersFieldName] as List<dynamic>;

      blockedUsersStream.add(UserData().blockedUserIds);
    } catch (_) {
      throw CouldNotFetchBlockedUsers();
    }
  }

  Future<void> _updateBlockUserList() async {
    try {
      await sharingDbInstance
          .doc(UserData().sharingDocumentId)
          .update({sharingBlockedUsersFieldName: UserData().blockedUserIds});
      blockedUsersStream.add(UserData().blockedUserIds);
    } catch (_) {
      throw CouldNotUpdateBlockListException();
    }
  }

  Future<void> blockUser({required String userIdToBlock}) async {
    try {
      UserData().blockedUserIds.add(userIdToBlock);
      await _updateBlockUserList();
    } catch (_) {
      throw CouldNotUpdateBlockListException();
    }
  }

  Future<void> unBlockUser({required String userBlockedId}) async {
    try {
      UserData().blockedUserIds.remove(userBlockedId);
      await _updateBlockUserList();
    } catch (_) {
      throw CouldNotUnblockUserException();
    }
  }
}
