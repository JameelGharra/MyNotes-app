import 'package:flutter/material.dart';
import 'package:mynotes/constants/routes.dart';
import 'package:mynotes/services/cloud/notes_service/cloud_note.dart';
import 'package:mynotes/services/cloud/notes_service/cloud_notes_storage.dart';
import 'package:mynotes/utilities/dialogs/delete_dialog.dart';
import 'package:mynotes/utilities/scroll/constant_scroll_behavior.dart';
import 'package:mynotes/utilities/time/time_formatter.dart';

typedef NoteCallBack = void Function(CloudNote note);

class NotesListView extends StatefulWidget {
  final List<CloudNote> notes;
  final NoteCallBack onDeleteNote;
  final NoteCallBack onTap;

  NotesListView({
    Key? key,
    required this.notes,
    required this.onDeleteNote,
    required this.onTap,
  }) : super(key: key) {
    notes.sort((a, b) => b.timeUtc.compareTo(a.timeUtc));
  }

  @override
  State<NotesListView> createState() => _NotesListViewState();
}

class _NotesListViewState extends State<NotesListView> {
  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      scrollBehavior: const ConstantScrollBehavior(),
      slivers: <Widget>[
        SliverAppBar(
          actions: [
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(createOrUpdateNoteRoute);
              },
              icon: const Icon(Icons.add),
            ),
            IconButton(
              onPressed: () {},
              icon: const Icon(Icons.dark_mode),
            )
          ],
          pinned: true,
          flexibleSpace: FlexibleSpaceBar(
            title: const Text(
              'Notes Inventory',
            ),
            background: DecoratedBox(
              position: DecorationPosition.foreground,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.center,
                  colors: <Color>[
                    Colors.transparent,
                    const Color.fromARGB(200, 224, 62, 79),
                    Colors.red[800]!,
                  ],
                ),
              ),
              child: Image.asset(
                'assets/images/pexels-pixabay-315791.jpg',
                fit: BoxFit.cover,
              ),
            ),
          ),
          expandedHeight: 65.0,
        ),
        SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              return InkWell(
                onTap: () {
                  widget.onTap(widget.notes[index]);
                },
                splashColor: const Color.fromARGB(200, 224, 62, 79),
                child: Card(
                    child: Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        setState(() {
                          NotesStorage()
                              .switchFavoured(note: widget.notes[index]);
                        });
                      },
                      splashRadius: 25.0,
                      color: Colors.red,
                      highlightColor: widget.notes[index].isFavoured
                          ? null
                          : const Color.fromARGB(180, 224, 62, 79),
                      splashColor: Colors.red,
                      icon: widget.notes[index].isFavoured
                          ? const Icon(Icons.favorite)
                          : const Icon(Icons.favorite_outline),
                      padding: const EdgeInsets.all(16.0),
                    ),
                    Expanded(
                      child: Text(
                        widget.notes[index].text,
                        style: const TextStyle(fontSize: 16.0),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        softWrap: true,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Text(
                              TimeFormatter.toCurrentTime(
                                  widget.notes[index].timeUtc),
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                            Text(
                              TimeFormatter.toCurrentDate(
                                  widget.notes[index].timeUtc),
                              style: const TextStyle(
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ]),
                    ),
                  ],
                )),
              );
            },
            childCount: widget.notes.length,
          ),
        )
      ],
    );
  }
}
    // return ListView.builder(
    //   itemCount: notes.length,
    //   itemBuilder: (context, index) {
    //     final note = notes.elementAt(index);
    //     return ListTile(
    //       onTap: () => onTap(note),
    //       title: Text(
    //         note.text,
    //         maxLines: 1,
    //         softWrap: true,
    //         overflow: TextOverflow.ellipsis,
    //       ),
    //       trailing: IconButton(
    //         onPressed: () async {
    //           final shouldDelete = await showDeleteDialog(context);
    //           if (shouldDelete) {
    //             onDeleteNote(note);
    //           }
    //         },
    //         icon: const Icon(Icons.delete),
    //       ),
    //     );
    //   },
    // );
