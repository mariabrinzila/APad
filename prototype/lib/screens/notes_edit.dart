import 'package:flutter/material.dart';

import '../models/note.dart';
import '../models/notes_database.dart';
import '../helpers/appBar_popMenu.dart';
import '../helpers/note_entry.dart';
import '../helpers/note_title_entry.dart';

const c1 = 0xFFFDFFFC,
    c2 = 0xFFFF595E,
    c3 = 0xFF374B4A,
    c4 = 0xFF00B1CC,
    c5 = 0xFFFFD65C,
    c6 = 0xFFB9CACA,
    c7 = 0x80374B4A;

class NotesEdit extends StatefulWidget {
  final args;

  const NotesEdit(this.args);
  _NotesEdit createState() => _NotesEdit();
}

class _NotesEdit extends State<NotesEdit> {
  String noteTitle = '';
  String noteContent = '';

  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _contentTextController = TextEditingController();

  void onSelectAppBarPopupMenuItem(
      BuildContext currentContext, String optionName) {
    switch (optionName) {
      case 'Delete':
        handleNoteDelete();
        break;

      case 'Bold':
        //textBold();
        break;

      case 'Italic':
        //textItalic();
        break;

      case 'Underlined':
        //textUnderlined();
        break;

      case 'Size':
        //textSize();
        break;

      case 'Font':
        //textFont();
        break;
    }
  }

  void handleNoteDelete() async {
    if (widget.args[0] == 'update') {
      try {
        NotesDatabase notesDb = NotesDatabase();
        await notesDb.initDatabase();
        int result = await notesDb.deleteNote(widget.args[1]['id']);
        await notesDb.closeDatabase();
      } catch (e) {
      } finally {
        Navigator.pop(context);
        return;
      }
    } else {
      Navigator.pop(context);
      return;
    }
  }

  void handleTitleTextChange() {
    setState(() {
      noteTitle = _titleTextController.text.trim();
    });
  }

  void handleNoteTextChange() {
    setState(() {
      noteContent = _contentTextController.text.trim();
    });
  }

  Future<void> _insertNote(Note note) async {
    NotesDatabase notesDb = NotesDatabase();
    await notesDb.initDatabase();
    int result = await notesDb.insertNote(note);
    await notesDb.closeDatabase();
  }

  Future<void> _updateNote(Note note) async {
    NotesDatabase notesDb = NotesDatabase();
    await notesDb.initDatabase();
    int result = await notesDb.updateNote(note);
    await notesDb.closeDatabase();
  }

  void handleBackButton() async {
    if (noteTitle.length == 0) {
      // Go Back without saving
      if (noteContent.length == 0) {
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
    // Save New note
    if (widget.args[0] == 'new') {
      Note noteObj = Note(title: noteTitle, content: noteContent);
      try {
        await _insertNote(noteObj);
      } catch (e) {
      } finally {
        Navigator.pop(context);
        return;
      }
    }
    // Update Note
    else if (widget.args[0] == 'update') {
      Note noteObj = Note(
          id: widget.args[1]['id'], title: noteTitle, content: noteContent);
      try {
        await _updateNote(noteObj);
      } catch (e) {
      } finally {
        Navigator.pop(context);
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();
    noteTitle = (widget.args[0] == 'new' ? '' : widget.args[1]['title']);
    noteContent = (widget.args[0] == 'new' ? '' : widget.args[1]['content']);

    _titleTextController.text =
        (widget.args[0] == 'new' ? '' : widget.args[1]['title']);
    _contentTextController.text =
        (widget.args[0] == 'new' ? '' : widget.args[1]['content']);
    _titleTextController.addListener(handleTitleTextChange);
    _contentTextController.addListener(handleNoteTextChange);
  }

  @override
  void dispose() {
    _titleTextController.dispose();
    _contentTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        handleBackButton();
        true;
      },
      child: Scaffold(
        backgroundColor: Color(c4),
        appBar: AppBar(
          backgroundColor: Color(c5),

          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: const Color(c1),
            ),
            tooltip: 'Back',
            onPressed: () => handleBackButton(),
          ),

          title: NoteTitleEntry(_titleTextController),

          // actions
          actions: [
            appBarPopMenu(
              parentContext: context,
              onSelectPopupmenuItem: onSelectAppBarPopupMenuItem,
            ),
          ],
        ),
        body: NoteEntry(_contentTextController),
      ),
    );
  }
}

/*
class NoteTitleEntry extends StatefulWidget {
  final _textFieldController;

  NoteTitleEntry(this._textFieldController);

  @override
  _NoteTitleEntry createState() => _NoteTitleEntry();
}

class _NoteTitleEntry extends State<NoteTitleEntry>
    with WidgetsBindingObserver {
  FocusNode _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset <= 0.0) {
      _textFieldFocusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: widget._textFieldController,
      focusNode: _textFieldFocusNode,
      decoration: InputDecoration(
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
      style: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        height: 1.5,
        color: Color(c1),
      ),
      textCapitalization: TextCapitalization.words,
    );
  }
}

class NoteEntry extends StatefulWidget {
  final _textFieldController;

  NoteEntry(this._textFieldController);

  @override
  _NoteEntry createState() => _NoteEntry();
}

class _NoteEntry extends State<NoteEntry> with WidgetsBindingObserver {
  FocusNode _textFieldFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void didChangeMetrics() {
    final bottomInset = WidgetsBinding.instance.window.viewInsets.bottom;
    if (bottomInset <= 0.0) {
      _textFieldFocusNode.unfocus();
    }
  }

  @override
  void dispose() {
    _textFieldFocusNode.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: TextField(
        controller: widget._textFieldController,
        focusNode: _textFieldFocusNode,
        maxLines: null,
        textCapitalization: TextCapitalization.sentences,
        decoration: null,
        style: TextStyle(
          fontSize: 19,
          height: 1.5,
        ),
      ),
    );
  }
}

// More Menu to display various options like Color, Sort, Share...
class appBarPopMenu extends StatelessWidget {
  final popupMenuButtonItems = const {
    1: {'name': 'Delete', 'icon': Icons.delete},
    2: {'name': 'Bold', 'icon': Icons.format_bold},
    3: {'name': 'Italic', 'icon': Icons.format_italic},
    4: {'name': 'Underlined', 'icon': Icons.format_underline},
    5: {'name': 'Size', 'icon': Icons.format_size},
    6: {'name': 'Font', 'icon': Icons.text_fields},
  };
  final parentContext;
  final void Function(BuildContext, String) onSelectPopupmenuItem;

  appBarPopMenu({
    @required this.parentContext,
    @required this.onSelectPopupmenuItem,
  });

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      icon: const Icon(
        Icons.more_vert,
        color: const Color(c1),
      ),
      color: Color(c1),
      itemBuilder: (context) {
        var list = popupMenuButtonItems.entries.map((entry) {
          return PopupMenuItem(
            child: Container(
              constraints: BoxConstraints(
                minWidth: MediaQuery.of(context).size.width * 0.3,
              ),
              child: Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: Icon(
                      entry.value['icon'],
                      color: const Color(c3),
                    ),
                  ),
                  Text(
                    entry.value['name'],
                    style: TextStyle(
                      color: Color(c3),
                    ),
                  ),
                ],
              ),
            ),
            value: entry.key,
          );
        }).toList();
        return list;
      },
      onSelected: (value) {
        onSelectPopupmenuItem(
            parentContext, popupMenuButtonItems[value]['name']);
      },
    );
  }
}*/
