import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/sharing_service/user_blocks.dart';
import 'package:mynotes/views/notes/blocked_users/blocked_users_list_view.dart';

class BlockedUsersView extends StatefulWidget {
  const BlockedUsersView({Key? key}) : super(key: key);

  @override
  State<BlockedUsersView> createState() => _BlockedUsersViewState();
}

class _BlockedUsersViewState extends State<BlockedUsersView> {
  late final UserBlocks _blockUserService;
  @override
  void initState() {
    _blockUserService = UserBlocks();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Blocked users',
        ),
      ),
      body: StreamBuilder(
        stream: _blockUserService.blockedUsersStream.stream,
        builder: ((context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
            case ConnectionState.active:
              {
                if (snapshot.hasData) {
                  return const BlockedUsersListView();
                }
                return const CircularProgressIndicator();
              }
            default:
              return const CircularProgressIndicator();
          }
        }),
      ),
    );
  }
}
