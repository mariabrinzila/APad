import 'package:flutter/material.dart';

import '../model/database_helper.dart';
import '../helpers/list_notes.dart';
import '../helpers/bottom_bar.dart';
import '../theme/colors.dart';

class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  List<Map<String, dynamic>> data;
  List<int> selectedIDs = [];

  // render the screen and update changes
  void afterNavigatorPop() {
    setState(() {});
  }

  // long press handler to display bottom bar
  void noteListLongPress(int id) {
    setState(() {
      if (selectedIDs.contains(id) == false) {
        selectedIDs.add(id);
      }
    });
  }

  // remove selection after long press
  void noteListTapAfterSelect(int id) {
    setState(() {
      if (selectedIDs.contains(id) == true) {
        selectedIDs.remove(id);
      }
    });
  }

  // delete notes handler
  void _deleteNotes() async {
    try {
      // open and initialize the database
      DatabaseHelper database = DatabaseHelper();
      int id;
      await database.initDatabase();

      // execute delete query for every id in selectedIDs
      for (id in selectedIDs) await database.deleteNote(id);

      // close the database
      await database.closeDatabase();

      //int result = await notesDb.deleteNote(id);
    } catch (e) {
      print(e);
    } finally {
      setState(() {
        selectedIDs = [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: menu,
        leading: (selectedIDs.length > 0
            ? IconButton(
                onPressed: () {
                  setState(() {
                    selectedIDs = [];
                  });
                },
                icon: Icon(
                  Icons.close,
                  color: icons,
                ),
              )
            : Container()),
        title: Text(
          (selectedIDs.length > 0
              ? ('Selected ' +
                  selectedIDs.length.toString() +
                  '/' +
                  data.length.toString())
              : 'APad'),
          style: TextStyle(
            color: text,
          ),
        ),
        actions: [
          (selectedIDs.length == 0
              ? Container()
              : IconButton(
                  onPressed: () {
                    setState(() {
                      selectedIDs =
                          data.map((item) => item['id'] as int).toList();
                    });
                  },
                  icon: Icon(
                    Icons.done_all,
                    color: icons,
                  ),
                ))
        ],
      ),

      //Floating Button
      floatingActionButton: (selectedIDs.length == 0
          ? FloatingActionButton(
              child: const Icon(
                Icons.note_add,
                color: icons,
              ),
              tooltip: 'Add note',
              backgroundColor: menu,
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  '/edit',
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
          future: getNotes(),
          // ignore: missing_return
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              data = snapshot.data;
              return Stack(
                children: <Widget>[
                  // Display Notes
                  ListNotes(
                    snapshot.data,
                    this.selectedIDs,
                    afterNavigatorPop,
                    noteListLongPress,
                    noteListTapAfterSelect,
                  ),

                  // Bottom Action Bar when Long Pressed
                  (selectedIDs.length > 0
                      ? BottomBar(deleteNote: _deleteNotes)
                      : Container()),
                ],
              );
            } else if (snapshot.hasError) {
            } else {
              return Center(
                child: CircularProgressIndicator(
                  backgroundColor: menu,
                ),
              );
            }
          }),
    );
  }
}

// get all notes from the database
Future<List<Map<String, dynamic>>> getNotes() async {
  try {
    // open and initialize the database
    DatabaseHelper database = DatabaseHelper();
    await database.initDatabase();

    // execute select * query
    List<Map> notesList = await database.selectAllNotes();

    // close the database
    await database.closeDatabase();

    List<Map<String, dynamic>> mappedNotes =
        List<Map<String, dynamic>>.from(notesList);

    //mappedNotes.sort((a, b) => (a['title']).compareTo(b['title']));

    return mappedNotes;
  } catch (e) {
    return [{}];
  }
}
