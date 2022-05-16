import 'package:flutter/material.dart';

import './notes.dart';
import './notes_control.dart';

// StatefulWidget <=> external and internal data changes lead to the UI being re-rendered
// constructor, initState, build, setState (builds the app again), didUpdateWidget (changes in the date)
class NotesManager extends StatefulWidget {
  final String startingNote;

  // positional arguments
  // default 'Note title'
  NotesManager({this.startingNote = 'Note title'});

  @override
  State<StatefulWidget> createState() {
    return _NotesManagerState();
  }
}

// State<NotesManager> makes the connection between the 2 classes
class _NotesManagerState extends State<NotesManager> {
  // final disallows us to use = more than once
  // _notes = const [] <=> unmodifiable list, value can't be changed
  final List<String> _notes = [];

  @override
  void initState() {
    _notes.add(widget.startingNote);

    // super refers to the NotesManager class
    // initState runs before build
    super.initState();
  }

  void _addNote(String note) {
    // setState calls build again (changes the app's state)
    setState(() {
      _notes.add(note);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          margin: const EdgeInsets.all(10.0),

          // _addNote() would pass the return (the function would be executed), not the reference to
          // the function
          child: NotesControl(_addNote),
        ),
        Notes(_notes),
      ],
    );
  }
}
