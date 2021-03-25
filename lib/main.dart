import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:note_flutter_app/Components/add_label.dart';
import 'package:note_flutter_app/Models/Label.dart';
import 'Components/custom_fab.dart';
import 'Components/custom_label.dart';
import 'Models/Note.dart';
import 'Models/User.dart';
import 'enums/note_type.dart';
import 'package:note_flutter_app/login.dart';
import 'extensions.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';

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

  @override
  Widget build(BuildContext context) {
    List<Widget> noteList = [];
    for (var note in widget.user.notes) {
      noteList.add(noteCard(note));
    }
    return Scaffold(
      backgroundColor: Theme.of(context).backgroundColor,
      appBar: AppBar(
        title: Text("Oversigt", style: TextStyle(color: Colors.white),),
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        shadowColor: Colors.transparent,
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: noteList,
            ),
          ),
        ]
      ),
      floatingActionButton: CustomFloatingActionButton(callback: () 
      {
        return showDialog(
          context: context, 
          builder: (context){
            noteType = NoteType.textDocument;
            return addNoteDialog();
          }
        );
      })
    );
  }

  Widget noteCard(Note note){
    Icon icon;
    switch (note.type) {
      case NoteType.textDocument:
        icon = Icon(Icons.description, color: Theme.of(context).backgroundColor, size: 40);
        break;
      case NoteType.list:
        icon = Icon(Icons.list_alt_outlined, color: Theme.of(context).backgroundColor, size: 40);
        break;
      case NoteType.checklist:
        icon = Icon(Icons.check_box, color: Theme.of(context).backgroundColor, size: 40);
        break;
      case NoteType.stickyNote:
        icon = Icon(Icons.sticky_note_2, color: Theme.of(context).backgroundColor, size: 40);
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
              child: Wrap(
                children: customLabels
              ),
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
                    onPressed: () {},
                  ),
                  IconButton(
                    alignment: Alignment.centerRight,
                    icon: Icon(Icons.edit), 
                    color: Theme.of(context).primaryColor,
                    onPressed: () {}
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget customTextField(TextEditingController controller){
    return Container(
      height: 35,
      child: TextFormField(
        controller: controller,
        style: TextStyle(
          color: Colors.black
        ),
        decoration: InputDecoration(
          hintText: "\"Indkøb\", \"Dansk\"...",
          hintStyle: TextStyle(color: Colors.grey, fontSize: 12),
          isDense: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18)
          ),
          filled: true,
          fillColor: Colors.white
        ),
      ),
    );
  }

  Widget addNoteDialog(){
      

    TextEditingController noteNameController = TextEditingController();
    TextEditingController labelNameController = TextEditingController();
    List<DropdownMenuItem<NoteType>> notelist = NoteType.values.map<DropdownMenuItem<NoteType>>((nt) => DropdownMenuItem(value: nt, child: Text(nt.toString()))).toList();
    Color pickerColor = Theme.of(context).primaryColor;
    Color currentColor = pickerColor;
    List<Label> assignedLabels = [];
    List<Widget> childrenLabels = [];
    List<Widget> labelList = [];

    return StatefulBuilder(builder: (context, setState) {
        
        if(widget.user.userLabels != null){
          widget.user.userLabels.forEach((ul) {
            labelList.add(
              CustomLabel(
                label: ul,
                onTap: (){
                  setState(() {
                    labelList.remove(ul);
                    assignedLabels.add(ul);                
                  });
                  print(assignedLabels.length);
                },
              )
            );
          });
          assignedLabels.forEach((al) {
            labelList.add(
              CustomLabel(
                label: al,
                onTap: (){
                  setState(() {
                    labelList.add(
                      CustomLabel(
                        label: al,
                        onTap: (){
                          setState(() {
                            labelList.remove(al);
                            assignedLabels.add(al);                    
                          });
                        },
                      )
                    );            
                    assignedLabels.remove(al);
                  });
                  print("HEJ");
                },
              )
            );
          });
        }
      return AlertDialog(
        scrollable: true,
        backgroundColor: Theme.of(context).backgroundColor,
        title: Text("Opret nyt dokument", textAlign: TextAlign.center,),
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
            customTextField(noteNameController),
            Padding(
              padding: const EdgeInsets.only(bottom: 5, top: 20),
              child: Align(
                alignment: Alignment.bottomLeft, 
                child: Text("Type"),
              ),
            ),
            AddLabelMenu<NoteType>(
              dropdownMenyItemList: notelist,
              onChanged: (newValue){
                setState((){
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
                    ? [Text('Ingen labels tilføjet', style: TextStyle(fontSize: 12))] 
                    : childrenLabels
              ),
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
                        style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
                        onPressed: () {
                          showDialog(
                            context: context, 
                            builder: (context){
                              return AlertDialog(
                                backgroundColor: Theme.of(context).backgroundColor,
                                title: Text('Ny label'),
                                content: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    customTextField(labelNameController),
                                    GestureDetector(
                                      onTap: (){
                                        showDialog(
                                          context: context,
                                          builder: (context){
                                            return AlertDialog(
                                              backgroundColor: Theme.of(context).backgroundColor,
                                              content: SingleChildScrollView(
                                                child: BlockPicker(
                                                  pickerColor: pickerColor,
                                                  onColorChanged: (newColor){
                                                    pickerColor = newColor;
                                                  },
                                                ),
                                              ),
                                              actions: [
                                                ElevatedButton(
                                                  child: Text("Anuller"),
                                                  style: ElevatedButton.styleFrom(primary: Colors.red),
                                                  onPressed: (){
                                                    setState((){
                                                      pickerColor = currentColor;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                                ElevatedButton(
                                                  child: Text("Bekræft"),
                                                  style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
                                                  onPressed: (){
                                                    setState((){
                                                      currentColor = pickerColor;
                                                    });
                                                    Navigator.of(context).pop();
                                                  },
                                                ),
                                              ],
                                            );
                                          }
                                        );
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
                                        style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
                                        onPressed: (){}
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                          );
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
                style: ElevatedButton.styleFrom(primary: Theme.of(context).primaryColor),
                onPressed: (){}
              ),
            )
          ],
        ),
      );
    });
  }
}
