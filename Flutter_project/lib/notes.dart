import 'package:flutter/material.dart';

// StatelessWidget <=> input data, renders UI
// constructor and build (draw something on the screen)
class Notes extends StatelessWidget {
  final List<String> notes;

  // optional arguments
  // default []
  Notes([this.notes = const []]);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: notes
          .map(
            (element) => Card(
              child: Column(
                children: [
                  //Image.asset('assets/img.jpg'),
                  Text('Note content'),
                  Text(element),
                ],
              ),
            ),
          )
          .toList(),
    );
  }
}
