class Note {
  final int id;
  final String title;
  final String content;
  final int color;

  Note(
      {this.id = 1,
      this.title = 'Title',
      this.content = 'Content',
      this.color = 0});

  Map<String, dynamic> toMap() {
    Map<String, dynamic> data = Map<String, dynamic>();

    data['id'] = id;
    data['title'] = title;
    data['content'] = content;
    data['color'] = color;

    return data;
  }

  @override
  String toString() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'color': color,
    }.toString();
  }
}
