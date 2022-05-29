import 'package:flutter/material.dart';

import 'package:share/share.dart';

import '../models/notes_database.dart';
import '../helpers/all_note_lists.dart';
import '../helpers/bottom_action_bar.dart';

const c1 = 0xFFFDFFFC,
    c2 = 0xFFFF595E,
    c3 = 0xFF374B4A,
    c4 = 0xFF00B1CC,
    c5 = 0xFFFFD65C,
    c6 = 0xFFB9CACA,
    c7 = 0x80374B4A,
    c8 = 0x3300B1CC,
    c9 = 0xCCFF595E;

/*
* Read all notes stored in database and sort them based on name 
*/
Future<List<Map<String, dynamic>>> readDatabase() async {
  try {
    NotesDatabase notesDb = NotesDatabase();
    await notesDb.initDatabase();
    List<Map> notesList = await notesDb.getAllNotes();

    await notesDb.closeDatabase();
    List<Map<String, dynamic>> notesData =
        List<Map<String, dynamic>>.from(notesList);
    notesData.sort((a, b) => (a['title']).compareTo(b['title']));
    return notesData;
  } catch (e) {
    return [{}];
  }
}

// Home Screen
class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  // Read Database and get Notes
  List<Map<String, dynamic>> notesData;
  List<int> selectedNoteIds = [];

  // Render the screen and update changes
  void afterNavigatorPop() {
    setState(() {});
  }

  // Long Press handler to display bottom bar
  void handleNoteListLongPress(int id) {
    setState(() {
      if (selectedNoteIds.contains(id) == false) {
        selectedNoteIds.add(id);
      }
    });
  }

  // Remove selection after long press
  void handleNoteListTapAfterSelect(int id) {
    setState(() {
      if (selectedNoteIds.contains(id) == true) {
        selectedNoteIds.remove(id);
      }
    });
  }

  // Delete Note/Notes
  void handleDelete() async {
    try {
      NotesDatabase notesDb = NotesDatabase();
      await notesDb.initDatabase();
      for (int id in selectedNoteIds) {
        int result = await notesDb.deleteNote(id);
      }
      await notesDb.closeDatabase();
    } catch (e) {
    } finally {
      setState(() {
        selectedNoteIds = [];
      });
    }
  }

  // Share Note/Notes
  void handleShare() async {
    String content = '';
    try {
      NotesDatabase notesDb = NotesDatabase();
      await notesDb.initDatabase();
      for (int id in selectedNoteIds) {
        dynamic notes = await notesDb.getNotes(id);
        if (notes != null) {
          content = content + notes['title'] + '\n' + notes['content'] + '\n\n';
        }
      }
      await notesDb.closeDatabase();
    } catch (e) {
    } finally {
      setState(() {
        selectedNoteIds = [];
      });
    }
    await Share.share(content.trim(), subject: content.split('\n')[0]);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(c6),
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: const Color(c2),
        leading: (selectedNoteIds.length > 0
            ? IconButton(
                onPressed: () {
                  setState(() {
                    selectedNoteIds = [];
                  });
                },
                icon: Icon(
                  Icons.close,
                  color: Color(c5),
                ),
              )
            :
            //AppBarLeading()
            Container()),
        title: Text(
          (selectedNoteIds.length > 0
              ? ('Selected ' +
                  selectedNoteIds.length.toString() +
                  '/' +
                  notesData.length.toString())
              : 'Note'),
          style: TextStyle(
            color: const Color(c5),
          ),
        ),
        actions: [
          (selectedNoteIds.length == 0
              ? Container()
              : IconButton(
                  onPressed: () {
                    setState(() {
                      selectedNoteIds =
                          notesData.map((item) => item['id'] as int).toList();
                    });
                  },
                  icon: Icon(
                    Icons.done_all,
                    color: Color(c5),
                  ),
                ))
        ],
      ),

      //Floating Button
      floatingActionButton: (selectedNoteIds.length == 0
          ? FloatingActionButton(
              child: const Icon(
                Icons.add,
                color: const Color(c5),
              ),
              tooltip: 'New Notes',
              backgroundColor: const Color(c4),
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/notes_edit',
                  arguments: [
                    'new',
                    [{}],
                  ],
                ).then((dynamic value) {
                  afterNavigatorPop();
                });
                return;
              },
            )
          : null),

      body: FutureBuilder(
          future: readDatabase(),
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              notesData = snapshot.data;
              return Stack(
                children: <Widget>[
                  // Display Notes
                  AllNoteLists(
                    snapshot.data,
                    this.selectedNoteIds,
                    afterNavigatorPop,
                    handleNoteListLongPress,
                    handleNoteListTapAfterSelect,
                  ),

                  // Bottom Action Bar when Long Pressed
                  (selectedNoteIds.length > 0
                      ? BottomActionBar(handleDelete: handleDelete)
                      : Container()),
                ],
              );
            } else if (snapshot.hasError) {
            } else {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: Color(c3),
                ),
              );
            }
          }),
    );
  }
}
