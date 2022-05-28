class NoteModel {
  int id;
  String title;
  String content;

  NoteModel({this.id = 0, this.title = 'Title', this.content = 'Content'});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = <String, dynamic>{};

    if (id != 0) data['id'] = id;

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
