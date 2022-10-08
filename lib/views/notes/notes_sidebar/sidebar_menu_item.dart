import 'package:flutter/material.dart';

@immutable
class SideBarMenuItem extends StatelessWidget {
  final String _text;
  final IconData _icon;
  static const Color _tileColor = Colors.white;
  static const Color _hoverColor = Colors.white70;
  final VoidCallback? _onClicked;

  const SideBarMenuItem({
    Key? key,
    required String text,
    required IconData icon,
    VoidCallback? onClicked,
  })  : _icon = icon,
        _text = text,
        _onClicked = onClicked,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 30.0),
      title: Text(
        _text,
        style: const TextStyle(color: _tileColor),
      ),
      hoverColor: _hoverColor,
      leading: Icon(
        _icon,
        color: _tileColor,
      ),
      onTap: _onClicked,
    );
  }
}
