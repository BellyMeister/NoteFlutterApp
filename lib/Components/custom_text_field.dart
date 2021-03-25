import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;

  const CustomTextField({Key key, this.controller}) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(18)),
          filled: true,
          fillColor: Colors.white
        ),
      ),
    );
  }
}