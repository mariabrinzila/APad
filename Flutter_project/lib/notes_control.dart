import 'package:flutter/material.dart';

// StatelessWidget <=> input data, renders UI
// constructor and build (draw something on the screen)
class NotesControl extends StatelessWidget {
  // Function stores the reference to a function
  final Function addNote;

  NotesControl(this.addNote);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        addNote('Note title x');
      },
      child: const Text('Add note'),
    );
  }
}
