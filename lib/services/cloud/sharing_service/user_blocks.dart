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
  late final StreamController<List<dynamic>> blockedUsersStream;
  static final UserBlocks _shared = UserBlocks._sharedInstance();
  UserBlocks._sharedInstance() {
    blockedUsersStream = StreamController<List<dynamic>>.broadcast(
      onListen: () {
        blockedUsersStream.sink.add(UserSharingData().blockedUserIds);
      },
    );
  }
  factory UserBlocks() => _shared;

  Future<void> cacheUserBlocks({required String userId}) async {
    try {
      final readDocForUser =
          await sharingDbInstance.doc(UserSharingData().documentId).get();
      UserSharingData().blockedUserIds =
          readDocForUser.data()![sharingBlockedUsersFieldName] as List<dynamic>;

      blockedUsersStream.add(UserSharingData().blockedUserIds);
    } catch (_) {
      print(_.toString());
      throw CouldNotFetchBlockedUsers();
    }
  }

  Future<void> _updateBlockUserList() async {
    try {
      await sharingDbInstance.doc(UserSharingData().documentId).update(
          {sharingBlockedUsersFieldName: UserSharingData().blockedUserIds});
      blockedUsersStream.add(UserSharingData().blockedUserIds);
    } catch (_) {
      throw CouldNotUpdateBlockListException();
    }
  }

  Future<void> blockUser({required String userIdToBlock}) async {
    try {
      UserSharingData().blockedUserIds.add(userIdToBlock);
      await _updateBlockUserList();
    } catch (_) {
      throw CouldNotUpdateBlockListException();
    }
  }

  Future<void> unBlockUser({required String userBlockedId}) async {
    try {
      UserSharingData().blockedUserIds.remove(userBlockedId);
      await _updateBlockUserList();
    } catch (_) {
      throw CouldNotUnblockUserException();
    }
  }
}
