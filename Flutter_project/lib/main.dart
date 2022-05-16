import 'package:flutter/material.dart';

import 'notes_manager.dart';

// called automatically by flutter
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('APad'),
        ),
        // targeted named argument
        body: NotesManager(startingNote: 'Note 1'),
      ),
    );
  }
}
