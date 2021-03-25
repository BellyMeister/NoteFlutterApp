import 'package:flutter/material.dart';
import 'package:note_flutter_app/Components/custom_fab.dart';
import 'package:note_flutter_app/Components/custom_text_field.dart';
import 'package:note_flutter_app/Models/Entry.dart';

import 'Models/Note.dart';
import 'Models/User.dart';

class CheckListView extends StatefulWidget {
  final User user;
  final Note note;
  const CheckListView({Key key, this.user, this.note}) : super(key: key);
  @override
  _CheckListViewState createState() => _CheckListViewState();
}

class _CheckListViewState extends State<CheckListView> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      body: ListView.builder(
        // padding: const EdgeInsets.all(8),
        itemCount: widget.note.entries.length,
        itemBuilder: (BuildContext context, int index) {
          return CheckboxListTile(
            value: widget.note.entries[index].done,
            title: Text(widget.note.entries[index].title),
            onChanged: (bool value){
              setState(() {
                widget.note.entries[index].done = value;
              });
            },
            controlAffinity: ListTileControlAffinity.leading,
          );
        },
      ),
      floatingActionButton: CustomFloatingActionButton(callback: (){
        showDialog(context: context, builder: (context){
          return AlertDialog(
            backgroundColor: Theme.of(context).backgroundColor,
            title: Text('Tilføj ny række'),
            content: Container(
              height: 70,
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Navn på række')
                    ),
                  ),
                  CustomTextField(controller: controller,)
                ],
              ),
            ),
            actions: [
              ElevatedButton(
                child: Text("Anuller"),
                style: ElevatedButton.styleFrom(primary: Colors.red),
                onPressed: (){
                  Navigator.of(context).pop();
                },
              ),
              ElevatedButton(
                child: Text("Tilføj"),
                style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
                onPressed: (){
                  setState(() {
                    widget.note.entries.add(Entry(
                      done: false,
                      title: controller.text
                    ));                
                  });
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        });
      }),
    );
  }
  void changeValue(bool value, int index){
    setState(() {
      widget.note.entries[index].done = value;
    });
  }
}
