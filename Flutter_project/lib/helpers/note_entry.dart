import 'package:flutter/material.dart';

class NoteEntry extends StatefulWidget {
  final _textFieldController;
  final _fontStyleController;
  final _fontSizeController;
  final _fontController;

  NoteEntry(this._textFieldController, this._fontStyleController,
      this._fontSizeController, this._fontController);

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
          fontSize: double.parse(widget._fontSizeController.text),
          height: 1.5,
          fontWeight: (widget._fontStyleController.text == 'bold'
              ? FontWeight.bold
              : FontWeight.normal),
          fontStyle: (widget._fontStyleController.text == 'italic'
              ? FontStyle.italic
              : FontStyle.normal),
          decoration: (widget._fontStyleController.text == 'underlined'
              ? TextDecoration.underline
              : TextDecoration.none),
          fontFamily: (widget._fontController.text == 'dancing'
              ? 'DancingScript'
              : (widget._fontController.text == 'indie'
                  ? 'IndieFlower'
                  : (widget._fontController.text == 'pacifico'
                      ? 'Pacifico'
                      : 'Tiro'))),
        ),
      ),
    );
  }
}
