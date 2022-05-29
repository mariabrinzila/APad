import 'package:flutter/material.dart';

import '../theme/colors.dart';

class TitleEntry extends StatefulWidget {
  final _textFieldController;

  TitleEntry(this._textFieldController);

  @override
  _TitleEntry createState() => _TitleEntry();
}

class _TitleEntry extends State<TitleEntry> with WidgetsBindingObserver {
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
        hintText: 'Note title',
        hintStyle: TextStyle(
          fontSize: 21,
          fontStyle: FontStyle.italic,
          height: 1.5,
          color: text,
        ),
      ),
      maxLength: 31,
      maxLines: 1,
      style: TextStyle(
        fontSize: 21,
        fontWeight: FontWeight.bold,
        height: 1.5,
        color: text,
      ),
      textCapitalization: TextCapitalization.words,
    );
  }
}
