import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/notes_sidebar/sidebar_header.dart';
import 'package:mynotes/views/notes/notes_sidebar/sidebar_menu_item.dart';

import '../../../services/auth/bloc/auth_bloc.dart';
import '../../../services/auth/bloc/auth_event.dart';

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
        child: ListView(padding: _menuPadding, children: <Widget>[
          const SizedBox(
            height: 40.0,
          ),
          const SideBarHeader(),
          const SizedBox(
            height: 48.0,
          ),
          const SideBarMenuItem(
            text: 'Blocks',
            icon: Icons.block,
          ),
          const SizedBox(
            height: 16.0,
          ),
          const SideBarMenuItem(
            text: 'Favourites',
            icon: Icons.favorite,
          ),
          const SizedBox(
            height: 16.0,
          ),
          const SideBarMenuItem(
            text: 'Info',
            icon: Icons.info,
          ),
          const SizedBox(
            height: 48.0,
          ),
          const Divider(
            color: Colors.white70,
            thickness: 1.5,
          ),
          const SizedBox(
            height: 48.0,
          ),
          SideBarMenuItem(
            text: 'Log out',
            icon: Icons.logout,
            onClicked: () async {
              final shouldLogout = await showLogOutDialog(context);
              if (shouldLogout) {
                context.read<AuthBloc>().add(const AuthEventLogOut());
              }
            },
          ),
        ]),
      ),
    );
  }
}
