import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/services.dart';
import 'package:note_flutter_app/Components/add_label.dart';
import 'package:note_flutter_app/Models/Label.dart';
import 'package:note_flutter_app/Models/Server.dart';
import 'package:note_flutter_app/richtexteditor.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'Components/custom_fab.dart';
import 'Components/custom_label.dart';
import 'Components/custom_text_field.dart';
import 'Models/Note.dart';
import 'Models/Server.dart';
import 'Models/User.dart';
import 'enums/note_type.dart';
import 'package:note_flutter_app/login.dart';
import 'extensions.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

import 'list_checkbox_view.dart';

void main() {
  runApp(Main());
}

class Main extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        textTheme: TextTheme(
          headline6: TextStyle(
            fontSize: 36.0,
            color: Colors.white,
          ),
        ),
        backgroundColor: HexColor.fromHex("#112D52"),
        primaryColor: HexColor.fromHex("#21E6C1"),
        accentColor: HexColor.fromHex("#1D416F"),
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
      ),
      home: Login(),
    );
  }
}

class NoteOverview extends StatefulWidget {
  final User user;

  const NoteOverview({Key key, this.user}) : super(key: key);

  @override
  _NoteOverviewState createState() => _NoteOverviewState();
}

class _NoteOverviewState extends State<NoteOverview> {
  NoteType noteType;
  bool _isVisible = true;
  ScrollController _hideButtonController;
  // final String title;
  // _NoteOverviewState(this.title);
  List<Widget> noteList = [];

@override
  initState(){
    super.initState();
    _isVisible = true;
    _hideButtonController = new ScrollController();
    _hideButtonController.addListener((){
      if(_hideButtonController.position.userScrollDirection == ScrollDirection.reverse){
        if(_isVisible == true) {
          /* only set when the previous state is false
            * Less widget rebuilds 
            */
          print("**** ${_isVisible} up"); //Move IO away from setState
          setState((){
            _isVisible = false;
          });
        }
      } else {
        if(_hideButtonController.position.userScrollDirection == ScrollDirection.forward){
          if(_isVisible == false) {
            /* only set when the previous state is false
              * Less widget rebuilds 
              */
              print("**** ${_isVisible} down"); //Move IO away from setState
            setState((){
              _isVisible = true;
            });
          }
        }
    }});
  }

  void openRitchTextEdit(context, note) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            new RichTextEditor(user: widget.user, note: note)));
  }

  void openTextEditor(context, note) {
    Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            new CheckListView(user: widget.user, note: note)));
  }

  logout(context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove("user_id");
    Navigator.pop(context);
    Navigator.of(context)
        .pushReplacement(MaterialPageRoute(builder: (context) => new Login()));
  }

  @override
  Widget build(BuildContext context) {
    noteList.clear();
    for (var note in widget.user.notes) {
      noteList.add(noteCard(note));
    }

    return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        appBar: AppBar(
          actions: [
            IconButton(
              alignment: Alignment.centerRight,
              icon: Icon(Icons.settings),
              color: HexColor.fromHex("#E05263"),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return Center(
                      child: AlertDialog(
                        content: Container(
                          width: 48.0,
                          height: 100.0,
                          child: Column(
                            children: [
                              Center(
                                child: Text("Want to logout?"),
                              ),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Color(0xFF21E6C1),
                                ),
                                child: Text('logout'),
                                onPressed: () => {logout(context)},
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  });
              },
            ),
          ],
          title: Text(
            "Oversigt",
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).backgroundColor,
          centerTitle: true,
          shadowColor: Colors.transparent,
        ),
        body: ListView(
          controller: _hideButtonController,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: noteList,
              ),
            ),
          ]
        ),
        floatingActionButton: Visibility(
          visible: _isVisible,
          child: CustomFloatingActionButton(callback: () {
            return showDialog(
              context: context,
              builder: (context) {
                noteType = NoteType.textDocument;
                return addNoteDialog();
              });
          }),
        ));
  }

  Widget noteCard(Note note) {
    Icon icon;
    switch (note.type) {
      case NoteType.textDocument:
        icon = Icon(Icons.description,
            color: Theme.of(context).backgroundColor, size: 40);
        break;
      case NoteType.list:
        icon = Icon(Icons.list_alt_outlined,
            color: Theme.of(context).backgroundColor, size: 40);
        break;
      case NoteType.checklist:
        icon = Icon(Icons.check_box,
            color: Theme.of(context).backgroundColor, size: 40);
        break;
      case NoteType.stickyNote:
        icon = Icon(Icons.sticky_note_2,
            color: Theme.of(context).backgroundColor, size: 40);
        break;
      default:
        icon = Icon(Icons.error, color: Colors.red);
    }

    List<CustomLabel> customLabels = [];
    for (var label in note.labels) {
      customLabels.add(CustomLabel(label: label));
    }
    return Card(
      color: Theme.of(context).accentColor,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 3, right: 3, bottom: 5),
              child: Wrap(children: customLabels),
            ),
            ListTile(
              dense: true,
              contentPadding: EdgeInsets.only(left: 0, right: 0),
              leading: icon,
              title: Text(note.title),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    alignment: Alignment.centerRight,
                    icon: Icon(Icons.delete),
                    color: HexColor.fromHex("#E05263"),
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return removeNoteDialog(note);
                          });
                    },
                  ),
                  IconButton(
                      alignment: Alignment.centerRight,
                      icon: Icon(Icons.edit),
                      color: Theme.of(context).primaryColor,
                      onPressed: () {
                        switch (note.type) {
                          case NoteType.textDocument:
                            openRitchTextEdit(context, note);
                            break;

                          case NoteType.checklist:
                            openTextEditor(context, note);
                            break;
                          default:
                        }
                      }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget removeNoteDialog(Note note) {
    return AlertDialog(
      title: Text('Er du sikker?'),
      backgroundColor: Theme.of(context).backgroundColor,
      content: Text(
          '${note.title} vil blive slettet for evigt. Denne handling kan IKKE fortrydes.'),
      actions: [
        ElevatedButton(
            child: Text("Annuller"),
            style: ElevatedButton.styleFrom(primary: Colors.red),
            onPressed: () {
              Navigator.of(context).pop();
            }),
        ElevatedButton(
            child: Text("Bekræft"),
            style: ElevatedButton.styleFrom(
                primary: Theme.of(context).primaryColor),
            onPressed: () {
              setState(() {
                Server().removeNote(note, widget.user.id);
              });
              Navigator.of(context).pop();
            })
      ],
    );
  }

  Widget addNoteDialog() {
    TextEditingController noteNameController = TextEditingController();
    TextEditingController labelNameController = TextEditingController();
    List<DropdownMenuItem<NoteType>> notelist = NoteType.values
        .map<DropdownMenuItem<NoteType>>(
            (nt) => DropdownMenuItem(value: nt, child: Text(nt.toString())))
        .toList();
    Color pickerColor = Theme.of(context).primaryColor;
    Color currentColor = pickerColor;
    List<Label> assignedLabels = [];
    List<Widget> childrenLabels = [];
    List<Widget> labelList = [];

    return StatefulBuilder(builder: (context, setState) {
      if (widget.user.userLabels != null) {
        widget.user.userLabels.forEach((ul) {
          labelList.add(CustomLabel(
            label: ul,
            onTap: () {
              setState(() {
                labelList.remove(ul);
                assignedLabels.add(ul);
              });
              print(assignedLabels.length);
            },
          ));
        });
        assignedLabels.forEach((al) {
          labelList.add(CustomLabel(
            label: al,
            onTap: () {
              setState(() {
                labelList.add(CustomLabel(
                  label: al,
                  onTap: () {
                    setState(() {
                      labelList.remove(al);
                      assignedLabels.add(al);
                    });
                  },
                ));
                assignedLabels.remove(al);
              });
              print("HEJ");
            },
          ));
        });
      }
      return AlertDialog(
        scrollable: true,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text(
          "Opret nyt dokument",
          textAlign: TextAlign.center,
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 5),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text("Titel"),
              ),
            ),
            CustomTextField(controller: noteNameController),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text("Type"),
              ),
            ),
            AddLabelMenu<NoteType>(
              dropdownMenyItemList: notelist,
              onChanged: (newValue) {
                setState(() {
                  noteType = newValue;
                });
              },
              value: noteType,
              isEnabled: true,
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text("Labels"),
              ),
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Wrap(
                  alignment: WrapAlignment.start,
                  children: childrenLabels.isEmpty
                      ? [
                          Text('Ingen labels tilføjet',
                              style: TextStyle(fontSize: 12))
                        ]
                      : childrenLabels),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text("Tilføj labels"),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 20),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 150,
                      height: 200,
                      child: ListView(
                        children: labelList,
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        child: Text('Tilføj ny label'),
                        style: ElevatedButton.styleFrom(
                            primary: Theme.of(context).primaryColor),
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (context) {
                                return AlertDialog(
                                  backgroundColor:
                                      Theme.of(context).backgroundColor,
                                  title: Text('Ny label'),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      CustomTextField(
                                          controller: labelNameController),
                                      GestureDetector(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return AlertDialog(
                                                  backgroundColor:
                                                      Theme.of(context)
                                                          .backgroundColor,
                                                  content:
                                                      SingleChildScrollView(
                                                    child: BlockPicker(
                                                      pickerColor: pickerColor,
                                                      onColorChanged:
                                                          (newColor) {
                                                        pickerColor = newColor;
                                                      },
                                                    ),
                                                  ),
                                                  actions: [
                                                    ElevatedButton(
                                                      child: Text("Anuller"),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary:
                                                                  Colors.red),
                                                      onPressed: () {
                                                        setState(() {
                                                          pickerColor =
                                                              currentColor;
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                    ElevatedButton(
                                                      child: Text("Bekræft"),
                                                      style: ElevatedButton
                                                          .styleFrom(
                                                              primary: Theme.of(
                                                                      context)
                                                                  .primaryColor),
                                                      onPressed: () {
                                                        setState(() {
                                                          currentColor =
                                                              pickerColor;
                                                        });
                                                        Navigator.of(context)
                                                            .pop();
                                                      },
                                                    ),
                                                  ],
                                                );
                                              });
                                        },
                                        child: Container(
                                          color: currentColor,
                                          width: 100,
                                          height: 50,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ElevatedButton(
                                            child: Text("Bekræft"),
                                            style: ElevatedButton.styleFrom(
                                                primary: Theme.of(context)
                                                    .primaryColor),
                                            onPressed: () {
                                              Label label = Label(
                                                  title:
                                                      labelNameController.text,
                                                  colorHex:
                                                      currentColor.toHex());

                                              widget.user.userLabels.add(label);
                                              setState(() {
                                                labelList.add(CustomLabel(
                                                  label: label,
                                                  onTap: () {
                                                    setState(() {
                                                      labelList.remove(label);
                                                      assignedLabels.add(label);
                                                    });
                                                    print(
                                                        assignedLabels.length);
                                                  },
                                                ));
                                              });
                                            }),
                                      ),
                                    ],
                                  ),
                                );
                              });
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                  child: Text("Bekræft"),
                  style: ElevatedButton.styleFrom(
                      primary: Theme.of(context).primaryColor),
                  onPressed: () {}),
            )
          ],
        ),
        actions: [
          ElevatedButton(
              child: Text("Annuller"),
              style: ElevatedButton.styleFrom(primary: Colors.red),
              onPressed: () {
                if (Server().addNote(
                        Note(
                          title: noteNameController.text,
                          labels: assignedLabels,
                          type: noteType,
                        ),
                        widget.user.id) !=
                    null) {
                  Navigator.of(context).pop();
                }
                print(noteNameController.text);
              }),
          ElevatedButton(
              child: Text("Bekræft"),
              style: ElevatedButton.styleFrom(
                  primary: Theme.of(context).primaryColor),
              onPressed: () {
                Note tempNote = Note(
                  title: noteNameController.text,
                  labels: assignedLabels,
                  type: noteType,
                );
                setState(() {
                  noteList.add(noteCard(tempNote));
                });
                widget.user.notes.add(tempNote);
                // TODO ULRIK DU SKAL NAVIGERE TIL DOKUMENTET DER ER BLEVET OPRETTET HER DIN DEJLIGE TABER
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text("Dokument oprettet"),
                ));
                print(noteNameController.text);
              }),
        ],
      );
    });
  }
}
