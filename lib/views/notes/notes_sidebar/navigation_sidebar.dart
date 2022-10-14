import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/utilities/dialogs/logout_dialog.dart';
import 'package:mynotes/views/notes/bloc/navigation_bloc.dart';
import 'package:mynotes/views/notes/bloc/navigation_event.dart';
import 'package:mynotes/views/notes/notes_sidebar/sidebar_header.dart';
import 'package:mynotes/views/notes/notes_sidebar/sidebar_menu_item.dart';

import '../../../services/auth/bloc/auth_bloc.dart';
import '../../../services/auth/bloc/auth_event.dart';

class NavigationSideBar extends StatelessWidget {
  final String _userId;
  final String _userEmail;
  static const _menuPadding = EdgeInsets.symmetric(
    horizontal: 10.0,
  );
  const NavigationSideBar({
    Key? key,
    required String userId,
    required String email,
  })  : _userId = userId,
        _userEmail = email,
        super(key: key);
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Material(
        color: const Color.fromARGB(255, 255, 0, 0),
        child: ListView(padding: _menuPadding, children: <Widget>[
          const SizedBox(
            height: 40.0,
          ),
          SideBarHeader(email: _userEmail),
          const SizedBox(
            height: 48.0,
          ),
          const SideBarMenuItem(
            text: 'Favourites',
            icon: Icons.favorite,
          ),
          const SizedBox(
            height: 16.0,
          ),
          SideBarMenuItem(
            text: 'Shared with me',
            icon: Icons.people_rounded,
            onClicked: () {
              context
                  .read<NavigationBloc>()
                  .add(NavigationEventSharedView(userId: _userId));
            },
          ),
          const SizedBox(
            height: 16.0,
          ),
          SideBarMenuItem(
            text: 'Blocks',
            icon: Icons.block,
            onClicked: () {
              context
                  .read<NavigationBloc>()
                  .add(const NavigationEventBlockView());
            },
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
