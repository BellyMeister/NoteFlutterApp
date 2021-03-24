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
