import 'package:flutter/material.dart';

import '../theme/colors.dart';

// A Note view showing title, first line of note and color
class NoteDisplay extends StatelessWidget {
  final noteData;
  final selectedIDs;
  final selectedNote;
  final afterNavigatorPop;
  final noteListLongPress;
  final noteListTapAfterSelect;

  NoteDisplay(
    this.noteData,
    this.selectedIDs,
    this.selectedNote,
    this.afterNavigatorPop,
    this.noteListLongPress,
    this.noteListTapAfterSelect,
  );

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 2.0),
      child: Material(
        elevation: 1,
        color: (selectedNote == false ? noteColor : selected),
        clipBehavior: Clip.hardEdge,
        borderRadius: BorderRadius.circular(5.0),
        child: InkWell(
          onTap: () {
            if (selectedNote == false) {
              if (selectedIDs.length == 0) {
                Navigator.pushNamed(
                  context,
                  '/edit',
                  arguments: [
                    'update',
                    noteData,
                  ],
                ).then((dynamic value) {
                  afterNavigatorPop();
                });
                return;
              } else {
                noteListLongPress(noteData['id']);
              }
            } else {
              noteListTapAfterSelect(noteData['id']);
            }
          },
          onLongPress: () {
            noteListLongPress(noteData['id']);
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  flex: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: (selectedNote == false ? menu : noteColor),
                          shape: BoxShape.circle,
                        ),
                        child: Padding(
                          padding: EdgeInsets.all(10),
                          child: (selectedNote == false
                              ? Icon(
                                  Icons.note,
                                  color: text,
                                  size: 21,
                                )
                              : Icon(
                                  Icons.check,
                                  color: menu,
                                  size: 21,
                                )),
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  flex: 5,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        noteData['title'] != null ? noteData['title'] : "",
                        style: TextStyle(
                          color: selectedTitle,
                          fontSize: 21,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Container(
                        height: 3,
                      ),
                      Text(
                        noteData['content'] != null
                            ? noteData['content'].split('\n')[0]
                            : "",
                        style: TextStyle(
                          color: text,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
