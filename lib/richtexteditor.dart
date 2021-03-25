import 'package:flutter/material.dart';

class RichTextEditor extends StatefulWidget {
  @override
  _RichTextEditorState createState() => _RichTextEditorState();
}

class _RichTextEditorState extends State<RichTextEditor> {
  void saveText(text) {
    // her skal auto save være
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
