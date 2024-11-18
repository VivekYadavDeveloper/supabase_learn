class NoteModel {
  int? id;
  String body;

  NoteModel({this.id, required this.body});

  factory NoteModel.fromMap(Map<String, dynamic> map) {
    return NoteModel(
      body: map['body'] as String,
      id: map['id'] as int,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'body': body,
    };
  }
}
