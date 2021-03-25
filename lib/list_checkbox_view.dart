import 'package:flutter/material.dart';

import 'Models/User.dart';

class CheckListView extends StatefulWidget {
  final User user;

  const CheckListView({Key key, this.user}) : super(key: key);
  @override
  _CheckListViewState createState() => _CheckListViewState();
}

class _CheckListViewState extends State<CheckListView> {
  final List<String> entries = <String>['A', 'B', 'C'];
  final List<int> colorCodes = <int>[600, 500, 100];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1D416F),
      appBar: AppBar(
        title: Text(
          "placeholdername",
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).backgroundColor,
        centerTitle: true,
        shadowColor: Colors.transparent,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(8),
        itemCount: entries.length,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            height: 50,
            color: Colors.amber[colorCodes[index]],
            child: Row(
              children: [
                Checkbox(
                  checkColor: Colors.greenAccent,
                  activeColor: Colors.red,
                  value: false,
                  onChanged: (bool value) {
                    setState(() {
                      return true;
                    });
                  },
                ),
                Text("hello"),
                IconButton(
                  icon: const Icon(Icons.edit),
                  color: Colors.blue,
                  onPressed: () {},
                ),
                IconButton(
                  icon: const Icon(Icons.delete),
                  color: Colors.blue,
                  onPressed: () {},
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
