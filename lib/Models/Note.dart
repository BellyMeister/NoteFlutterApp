import 'package:mongo_dart/mongo_dart.dart';
import 'package:note_flutter_app/Models/sticky_note.dart';
import 'package:note_flutter_app/enums/note_type.dart';
import 'Entry.dart';

class Note {
  ObjectId id;
  String title;
  NoteType type;
  String bodyText;
  List<StickyNote> stickyNotes;
  List<Entry> entries;

  Note({this.title, this.type, this.bodyText, this.stickyNotes, this.entries});

  Note.fromJson(Map<String, dynamic> json) {
    id = json['_id'] != null ? json['_id'] : "";
    title = json['title'];
    type = NoteType.values[json['type']];
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
    data['_id'] = this.id;
    data['title'] = this.title;
    data['type'] = this.type.toString();
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
