import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_learn/Model/note_model.dart';

class NoteDatabase {
  final database = Supabase.instance.client.from('notes');

/*CREATE*/

  Future createNote(NoteModel newNote) async {
    await database.insert(newNote.toMap());
  }

/*READ*/
  final stream = Supabase.instance.client.from('notes').stream(
    primaryKey: ['id'],
  ).map((data) => data.map((noteMap) => NoteModel.fromMap(noteMap)).toList());

  /*UPDATE*/

  Future updateNote(NoteModel oldNote, String newBody) async {
    await database.update({'body': newBody}).eq('id', oldNote.id!);
  }

/*DELETE*/

  Future deleteNote(NoteModel note) async {
    await database.delete().eq('id', note.id!);
  }
}
