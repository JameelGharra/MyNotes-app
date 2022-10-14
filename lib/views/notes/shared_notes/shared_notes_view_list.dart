import 'package:flutter/material.dart';
import 'package:mynotes/services/cloud/user_administration/user_data.dart';

class SharedNotesListView extends StatelessWidget {
  const SharedNotesListView({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: UserData().sharedNotes.length,
      itemBuilder: ((context, index) {
        return ListTile(title: Text(UserData().sharedNotes[index].text));
      }),
    );
  }
}
