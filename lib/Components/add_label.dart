import 'package:flutter/material.dart';

class AddLabelMenu<NoteType> extends StatelessWidget {
  final List<DropdownMenuItem<NoteType>> dropdownMenyItemList;
  final ValueChanged<NoteType> onChanged;
  final NoteType value;
  final bool isEnabled;

  const AddLabelMenu({Key key, this.dropdownMenyItemList, this.onChanged, this.value, this.isEnabled}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: !isEnabled,
      child: Container(
        height: 35,
        padding: EdgeInsets.only(left: 10, right: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(18)),
          border: Border.all(
            color: Colors.white, 
            width: 1,
          ),
          color: Colors.white,
        ),
        child: DropdownButtonHideUnderline(
          child: DropdownButton(
            dropdownColor: Colors.white,
            isExpanded: true,
            itemHeight: 50,
            style: TextStyle(
              fontSize: 15,
              color: Colors.black
            ),
            items: dropdownMenyItemList,
            onChanged: onChanged,
            value: value,
          ),
        ),
      ),
    );
  }
}