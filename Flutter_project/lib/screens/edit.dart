import 'package:flutter/material.dart';

import '../model/note.dart';
import '../model/database_helper.dart';
import '../helpers/pop_up_menu.dart';
import '../helpers/note_entry.dart';
import '../helpers/title_entry.dart';
import '../theme/colors.dart';

class Edit extends StatefulWidget {
  final args;

  const Edit(this.args);
  _Edit createState() => _Edit();
}

class _Edit extends State<Edit> {
  String title = '';
  String content = '';

  TextEditingController _titleTextController = TextEditingController();
  TextEditingController _contentTextController = TextEditingController();

  void onSelectButton(BuildContext currentContext, String optionName) {
    switch (optionName) {
      case 'Delete':
        _deleteNote();
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

      case 'Size +':
        //textSizePlus();
        break;

      case 'Size -':
        //textSizeMinus();
        break;
    }
  }

  // delete note
  void _deleteNote() async {
    if (widget.args[0] == 'update') {
      try {
        // open and initialize database
        DatabaseHelper database = DatabaseHelper();
        await database.initDatabase();

        // execute delete query
        await database.deleteNote(widget.args[1]['id']);

        // close database
        await database.closeDatabase();
      } catch (e) {
        print(e);
      } finally {
        Navigator.pop(context);
        return;
      }
    } else {
      Navigator.pop(context);
      return;
    }
  }

  // insert note (save note)
  Future<void> _insertNote(Note note) async {
    // open and initialize database
    DatabaseHelper database = DatabaseHelper();
    await database.initDatabase();

    // execute insert query
    await database.insertNote(note);

    // close database
    await database.closeDatabase();
  }

  // update note
  Future<void> _updateNote(Note note) async {
    // open and initialize database
    DatabaseHelper database = DatabaseHelper();
    await database.initDatabase();

    // execute update query
    await database.updateNote(note);

    // close database
    await database.closeDatabase();
  }

  // title change handler
  void titleTextChange() {
    setState(() {
      title = _titleTextController.text.trim();
    });
  }

  // content change handler
  void contentChange() {
    setState(() {
      content = _contentTextController.text.trim();
    });
  }

  // bold handler
  textBold() {}

  // italic handler
  textItalic() {}

  // underlined handler
  textUnderlined() {}

  // back button handler
  void backButton() async {
    if (title.length == 0) {
      // not saving
      if (content.length == 0) {
        Navigator.pop(context);

        return;
      } else {
        String title = content.split('\n')[0];

        if (title.length > 31) title = title.substring(0, 31);

        setState(() {
          title = title;
        });
      }
    }

    // save the new note
    if (widget.args[0] == 'new') {
      Note newNote = Note(title: title, content: content);

      try {
        await _insertNote(newNote);
      } catch (e) {
        print(e);
      } finally {
        Navigator.pop(context);
        return;
      }
    }

    // update the existing note
    else if (widget.args[0] == 'update') {
      Note existingNote =
          Note(id: widget.args[1]['id'], title: title, content: content);
      try {
        await _updateNote(existingNote);
      } catch (e) {
        print(e);
      } finally {
        Navigator.pop(context);
        return;
      }
    }
  }

  @override
  void initState() {
    super.initState();

    title = (widget.args[0] == 'new' ? '' : widget.args[1]['title']);
    content = (widget.args[0] == 'new' ? '' : widget.args[1]['content']);

    _titleTextController.text =
        (widget.args[0] == 'new' ? '' : widget.args[1]['title']);
    _contentTextController.text =
        (widget.args[0] == 'new' ? '' : widget.args[1]['content']);

    _titleTextController.addListener(titleTextChange);
    _contentTextController.addListener(contentChange);
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
      // ignore: missing_return
      onWillPop: () async {
        backButton();
        true;
      },
      child: Scaffold(
        backgroundColor: background,
        appBar: AppBar(
          backgroundColor: menu,
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: icons,
              size: 25,
            ),
            tooltip: 'Back',
            onPressed: () => backButton(),
          ),
          title: TitleEntry(_titleTextController),
          actions: [
            PopUpMenu(
              parentContext: context,
              onSelect: onSelectButton,
            ),
          ],
        ),
        body: NoteEntry(_contentTextController),
      ),
    );
  }
}
