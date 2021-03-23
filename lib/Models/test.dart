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

class Note {
  String title;
  String type;
  String bodyText;
  List<StickyNote> stickyNotes;
  List<Entry> entries;

  Note({this.title, this.type, this.bodyText, this.stickyNotes, this.entries});

  Note.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    type = json['type'];
    bodyText = json['bodyText'];
    if (json['stickyNotes'] != null) {
      stickyNotes = <StickyNote>[];
      json['stickyNotes'].forEach((v) {
        stickyNotes.add(new StickyNote.fromJson(v));
      });
    }
    if (json['entries'] != null) {
      entries = <Entry>[];
      json['entries'].forEach((v) {
        entries.add(new Entry.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['type'] = this.type;
    data['bodyText'] = this.bodyText;
    if (this.stickyNotes != null) {
      data['stickyNotes'] = this.stickyNotes.map((v) => v.toJson()).toList();
    }
    if (this.entries != null) {
      data['entries'] = this.entries.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class StickyNote {
  String title;
  String bodyText;
  String colorHex;

  StickyNote({this.title, this.bodyText, this.colorHex});

  StickyNote.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    bodyText = json['bodyText'];
    colorHex = json['colorHex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['bodyText'] = this.bodyText;
    data['colorHex'] = this.colorHex;
    return data;
  }
}

class Entry {
  String title;
  bool done;

  Entry({this.title, this.done});

  Entry.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['done'] = this.done;
    return data;
  }
}

class Label {
  String title;
  String colorHex;

  Label({this.title, this.colorHex});

  Label.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    colorHex = json['colorHex'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    data['colorHex'] = this.colorHex;
    return data;
  }
}
