import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/views/notes/bloc/navigation_bloc.dart';
import 'package:mynotes/views/notes/bloc/navigation_event.dart';
import 'package:mynotes/views/notes/bloc/navigation_state.dart';
import 'package:mynotes/views/notes/notes_view.dart';

class NotesNavigator extends StatelessWidget {
  const NotesNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<NavigationBloc>().add(const NavigationEventInitialize());
    return BlocListener<NavigationBloc, NavigationState>(
      listener: (context, state) {
        if (state.stateRoute != null) {
          Navigator.of(context).pop(); // drawer
          Navigator.of(context).pushNamed(state.stateRoute!).whenComplete(() {
            context.read<NavigationBloc>().add(const NavigationEventNoteView());
          });
        }
      },
      child: const NotesView(),
    );
  }
}
