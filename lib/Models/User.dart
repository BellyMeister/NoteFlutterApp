import 'package:mongo_dart/mongo_dart.dart';

import 'Note.dart';

class User {
  ObjectId id;
  String name;
  String username;
  String password;
  List<Note> notes;

  User({
    this.id,
    this.name,
    this.username,
    this.password,
    this.notes,
  });

  User.fromJson(Map<String, dynamic> json) {
    id = json['_id'] != null ? json['_id'] : "";
    name = json['name'];
    username = json['username'];
    password = json['password'];
    if (json['notes'] != null) {
      notes = <Note>[];
      json['notes'].forEach((v) {
        notes.add(new Note.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['_id'] = this.id;
    data['name'] = this.name;
    data['username'] = this.username;
    data['password'] = this.password;
    if (this.notes != null) {
      data['notes'] = this.notes.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
