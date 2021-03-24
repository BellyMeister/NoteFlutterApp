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
