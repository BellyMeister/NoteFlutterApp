import 'package:flutter/material.dart';

class CustomFloatingActionButton extends StatelessWidget {
  final Function callback;

  const CustomFloatingActionButton({Key key, this.callback}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      type: MaterialType.transparency,
      child: Ink(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.white, width: 4),
          color: Theme.of(context).primaryColor,
          shape: BoxShape.circle,
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(1000),
          onTap: callback,
          child: Padding(
            padding: EdgeInsets.all(5),
            child: Icon(
              Icons.add,
              size: 50,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}