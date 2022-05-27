import 'package:flutter/material.dart';

import 'add_note.dart';

// Home Screen
class Home extends StatefulWidget {
  @override
  _Home createState() => _Home();
}

class _Home extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'APad',
      home: Scaffold(
        backgroundColor: const Color.fromARGB(255, 219, 181, 232),
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: const Color.fromARGB(255, 89, 19, 112),
          title: const Text(
            'APad',
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
            ),
          ),
        ),

        //Floating Button
        floatingActionButton: FloatingActionButton(
          child: const Icon(
            Icons.add,
            color: Color.fromARGB(255, 229, 196, 241),
          ),
          tooltip: 'Add a new note',
          backgroundColor: const Color.fromARGB(255, 89, 19, 112),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddNote()),
            );
          },
        ),
      ),
    );
  }
}
