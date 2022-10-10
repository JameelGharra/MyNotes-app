import 'package:flutter/material.dart';

class BlockedUsersView extends StatefulWidget {
  const BlockedUsersView({Key? key}) : super(key: key);

  @override
  State<BlockedUsersView> createState() => _BlockedUsersViewState();
}

class _BlockedUsersViewState extends State<BlockedUsersView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: const Text(
        'Blocked users',
      )),
    );
  }
}
