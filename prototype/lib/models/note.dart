class Note {
  int id;
  String title;
  String content;

  Note({this.id = null, this.title = "Note", this.content = "Text"});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();
    if (id != null) {
      data['id'] = id;
    }

    data['title'] = title;
    data['content'] = content;

    return data;
  }

  @override
  toString() {
    return {
      'id': id,
      'title': title,
      'content': content,
    }.toString();
  }
}
