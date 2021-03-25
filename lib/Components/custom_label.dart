import 'package:flutter/material.dart';
import 'package:note_flutter_app/Models/Label.dart';
import 'package:note_flutter_app/extensions.dart';

class CustomLabel extends StatelessWidget {
  final Label label;
  final Function onTap;

  const CustomLabel({Key key, this.label, this.onTap}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Color color = HexColor.fromHex('${label.colorHex}');
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 10, 5, 0),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.all(Radius.circular(20))
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              label.title, 
              style: TextStyle(
                fontWeight: FontWeight.bold, 
                color: color.computeLuminance() > 0.5 ? Colors.black : Colors.white
              )
            ),
          ),
        ),
      ),
    );
  }
}