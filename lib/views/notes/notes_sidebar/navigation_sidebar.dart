import 'package:flutter/material.dart';
import 'package:mynotes/views/notes/notes_sidebar/sidebar_header.dart';
import 'package:mynotes/views/notes/notes_sidebar/sidebar_menu_item.dart';

class NavigationSideBar extends StatelessWidget {
  static const _menuPadding = EdgeInsets.symmetric(
    horizontal: 10.0,
  );
  const NavigationSideBar({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: const Color.fromARGB(255, 255, 0, 0),
        child: ListView(padding: _menuPadding, children: const <Widget>[
          SizedBox(
            height: 40.0,
          ),
          SideBarHeader(),
          SizedBox(
            height: 48.0,
          ),
          SideBarMenuItem(
            text: 'Blocks',
            icon: Icons.block,
          ),
          SizedBox(
            height: 16.0,
          ),
          SideBarMenuItem(
            text: 'Favourites',
            icon: Icons.favorite,
          ),
          SizedBox(
            height: 16.0,
          ),
          SideBarMenuItem(
            text: 'Info',
            icon: Icons.info,
          ),
          SizedBox(
            height: 48.0,
          ),
          Divider(
            color: Colors.white70,
            thickness: 1.5,
          ),
          SizedBox(
            height: 48.0,
          ),
          SideBarMenuItem(
            text: 'Log out',
            icon: Icons.logout,
          ),
        ]),
      ),
    );
  }
}
