import 'package:flutter/material.dart';
import 'package:note_flutter_app/Models/Note.dart';

import 'Models/User.dart';

class RichTextEditor extends StatefulWidget {
  final User user;

  const RichTextEditor({Key key, this.user}) : super(key: key);
  @override
  _RichTextEditorState createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  void saveText(text) {
    // her skal auto save være
    User user = User();
    Note newnote = Note();

    newnote.bodyText = text;

    print("First text field: $text");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D416F),
      appBar: AppBar(
        title: Text(
          "Oversigt",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                TextField(
                  onChanged: (text) {
                    saveText(text);
                  },
                  keyboardType: TextInputType.multiline,
                  minLines: 1, //Normal textInputField will  be displayed
                  maxLines: null, // when user presses enter it will adapt to it
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
