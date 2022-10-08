import 'package:flutter/material.dart';

class SideBarHeader extends StatelessWidget {
  const SideBarHeader({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const ListTile(
      tileColor: Color.fromARGB(255, 247, 82, 70),
      hoverColor: Colors.white70,
      leading: Icon(
        Icons.account_circle,
        color: Colors.white,
      ),
      title: Text('jameelgharra@gmail.com',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
          )),
      subtitle: Text('The high roller!',
          style: TextStyle(
            color: Colors.yellow,
            fontWeight: FontWeight.bold,
            fontStyle: FontStyle.italic,
          )),
    );
  }
}
