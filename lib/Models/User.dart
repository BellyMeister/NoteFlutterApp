import 'Label.dart';
import 'Note.dart';

class User {
  Id iId;
  String name;
  String username;
  String password;
  List<Note> notes;
  List<Label> labels;

  User(
      {this.iId,
      this.name,
      this.username,
      this.password,
      this.notes,
      this.labels});

  User.fromJson(Map<String, dynamic> json) {
    iId = json['_id'] != null ? new Id.fromJson(json['_id']) : null;
    name = json['name'];
    username = json['username'];
    password = json['password'];
    if (json['notes'] != null) {
      notes = <Note>[];
      json['notes'].forEach((v) {
        notes.add(new Note.fromJson(v));
      });
    }
    if (json['labels'] != null) {
      labels = <Label>[];
      json['labels'].forEach((v) {
        labels.add(new Label.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.iId != null) {
      data['_id'] = this.iId.toJson();
    }
    data['name'] = this.name;
    data['username'] = this.username;
    data['password'] = this.password;
    if (this.notes != null) {
      data['notes'] = this.notes.map((v) => v.toJson()).toList();
    }
    if (this.labels != null) {
      data['labels'] = this.labels.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Id {
  String oid;

  Id({this.oid});

  Id.fromJson(Map<String, dynamic> json) {
    oid = json['$oid'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['$oid'] = this.oid;
    return data;
  }
}
