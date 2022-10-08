import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mynotes/views/notes/bloc/navigation_bloc.dart';
import 'package:mynotes/views/notes/bloc/navigation_event.dart';
import 'package:mynotes/views/notes/bloc/navigation_state.dart';
import 'package:mynotes/views/notes/notes_view.dart';

class NotesNavigator extends StatelessWidget {
  const NotesNavigator({super.key});

  @override
  Widget build(BuildContext context) {
    context.read<NavigationBloc>().add(const NavigationNoteViewEvent());
    return BlocBuilder<NavigationBloc, NavigationState>(
      builder: (context, state) {
        if (state is NavigationStateNotesView) {
          return const NotesView();
        } else {
          return const CircularProgressIndicator();
        }
      },
    );
  }
}
