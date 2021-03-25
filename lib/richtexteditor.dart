import 'package:flutter/material.dart';
import 'package:note_flutter_app/Models/Note.dart';

import 'Models/User.dart';

class RichTextEditor extends StatefulWidget {
  final User user;
  final Note note;
  const RichTextEditor({Key key, this.user, this.note}) : super(key: key);
  @override
  _RichTextEditorState createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  void onBackPressed() {
    print(widget.note.bodyText);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        onBackPressed();
        return true; // Action to perform on back pressed
      },
      child: Scaffold(
        backgroundColor: const Color(0xFF1D416F),
        appBar: AppBar(
          title: Text(
            widget.note.title,
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
                    controller: TextEditingController()
                      ..text = widget.note.bodyText,
                    onChanged: (text) {
                      widget.note.bodyText = text;
                    },
                    keyboardType: TextInputType.multiline,
                    minLines: 1, //Normal textInputField will  be displayed
                    maxLines:
                        null, // when user presses enter it will adapt to it
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
