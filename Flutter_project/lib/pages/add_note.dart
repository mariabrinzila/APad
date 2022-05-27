import 'package:flutter/material.dart';

import '../models/colors.dart';
import '../models/note.dart';
import '../models/note_database.dart';

const c1 = 0xFFFDFFFC,
    c2 = 0xFFFF595E,
    c3 = 0xFF374B4A,
    c4 = 0xFF00B1CC,
    c5 = 0xFFFFD65C,
    c6 = 0xFFB9CACA,
    c7 = 0x80374B4A;

class AddNote extends StatefulWidget {
  @override
  _AddNote createState() => _AddNote();
}

class _AddNote extends State<AddNote> {
  String noteTitle = '';
  String noteContent = '';
  String noteColor = 'red';
  NoteDatabase noteDb = NoteDatabase();

  final TextEditingController _titleTextController = TextEditingController();
  final TextEditingController _contentTextController = TextEditingController();

  _AddNote() {
    noteDb.initDatabase();
  }

  void title() {
    setState(() {
      noteTitle = _titleTextController.text.trim();
    });
  }

  void content() {
    setState(() {
      noteContent = _contentTextController.text.trim();
    });
  }

  void color(currentContext) {
    showDialog(
      context: currentContext,
      builder: (context) => ColorPalette(
        parentContext: currentContext,
      ),
    ).then((colorName) {
      if (colorName != null) {
        setState(() {
          noteColor = colorName;
        });
      }
    });
  }

  Future<int> _lastID() async {
    int id = await noteDb.selectLastID();

    return id;
  }

  Future<void> _insertNote(Note note) async {
    await noteDb.insertNote(note);
  }

  Future<void> _selectAllNotes() async {
    print("---------------------------");

    var result = await noteDb.selectAllNotes();
    print(result);

    print("---------------------------");
  }

  void backButton() async {
    if (noteTitle.isEmpty) {
      // Go Back without saving
      if (noteContent.isEmpty) {
        Navigator.pop(context);
        return;
      } else {
        String title = noteContent.split('\n')[0];
        if (title.length > 31) {
          title = title.substring(0, 31);
        }
        setState(() {
          noteTitle = title;
        });
      }
    }

    print("----------------------------------------");

    var noteID = await _lastID();
    noteID += 1;

    print(noteID);

    print("----------------------------------------");

    // make a new note
    Note newNote = Note(
        id: noteID, title: noteTitle, content: noteContent, color: noteColor);

    // insert the new note in the database
    try {
      await _insertNote(newNote);
    } catch (e) {
      print('Error inserting row');
    } finally {
      Navigator.pop(context);
      return;
    }
  }

  @override
  void initState() {
    super.initState();

    _titleTextController.addListener(title);
    _contentTextController.addListener(content);
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _contentTextController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(c1),
      //Color(noteColors[noteColor]!['l']),
      appBar: AppBar(
        backgroundColor: const Color(c2),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back,
            color: Color(c1),
          ),
          tooltip: 'Back',
          onPressed: () => backButton(),
        ),
        title: NoteTitleEntry(_titleTextController),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.color_lens,
              color: Color(c1),
            ),
            tooltip: 'Color Palette',
            onPressed: () => color(context),
          ),
        ],
      ),
      body: NoteEntry(_contentTextController),
    );
  }
}

class NoteTitleEntry extends StatelessWidget {
  final _textFieldController;

  NoteTitleEntry(this._textFieldController);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _textFieldController,
      decoration: const InputDecoration(
        border: InputBorder.none,
        focusedBorder: InputBorder.none,
        enabledBorder: InputBorder.none,
        errorBorder: InputBorder.none,
        disabledBorder: InputBorder.none,
        contentPadding: EdgeInsets.all(0),
        counter: null,
        counterText: "",
        hintText: 'Title',
        hintStyle: TextStyle(
          fontSize: 21,
          fontWeight: FontWeight.bold,
          height: 1.5,
        ),
      ),
      maxLength: 31,
      maxLines: 1,
      style: const TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        height: 1.5,
        color: Color(c1),
      ),
      textCapitalization: TextCapitalization.words,
    );
  }
}

class NoteEntry extends StatelessWidget {
  final _textFieldController;

  NoteEntry(this._textFieldController);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: TextField(
        controller: _textFieldController,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        decoration: null,
        style: const TextStyle(
          fontSize: 19,
          height: 1.5,
        ),
      ),
    );
  }
}

class ColorPalette extends StatelessWidget {
  final parentContext;

  const ColorPalette({
    @required this.parentContext,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(c1),
      clipBehavior: Clip.hardEdge,
      insetPadding: EdgeInsets.all(MediaQuery.of(context).size.width * 0.03),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(2),
      ),
      child: Container(
        padding: const EdgeInsets.all(8),
        child: Wrap(
          alignment: WrapAlignment.start,
          spacing: MediaQuery.of(context).size.width * 0.02,
          runSpacing: MediaQuery.of(context).size.width * 0.02,
          children: noteColors.entries.map((entry) {
            return GestureDetector(
              onTap: () => Navigator.of(context).pop(entry.key),
              child: Container(
                width: MediaQuery.of(context).size.width * 0.12,
                height: MediaQuery.of(context).size.width * 0.12,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                      MediaQuery.of(context).size.width * 0.06),
                  color: Color(entry.value),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}
