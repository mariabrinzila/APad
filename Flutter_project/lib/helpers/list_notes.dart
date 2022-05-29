import 'package:flutter/material.dart';

import '../helpers/note_display.dart';

// Display all notes
class ListNotes extends StatelessWidget {
  final data;
  final selectedIDs;
  final navigatorPop;
  final noteListLongPress;
  final noteListTapAfterSelect;

  ListNotes(
    this.data,
    this.selectedIDs,
    this.navigatorPop,
    this.noteListLongPress,
    this.noteListTapAfterSelect,
  );

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          dynamic item = data[index];
          return NoteDisplay(
            item,
            selectedIDs,
            (selectedIDs.contains(item['id']) == false ? false : true),
            navigatorPop,
            noteListLongPress,
            noteListTapAfterSelect,
          );
        });
  }
}
