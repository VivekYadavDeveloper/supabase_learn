
import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:supabase_learn/view/profile_page.dart';

class NotePage extends StatefulWidget {
  const NotePage({super.key});

  @override
  State<NotePage> createState() => _NotePageState();
}

class _NotePageState extends State<NotePage> {
  final TextEditingController textEditingController = TextEditingController();

  // final NoteDatabase noteDatabase = NoteDatabase();

  /*-------------------------------------------------------*/
  /*
  CREATE/ADD-NOTE WIDGET  - A Note and Save in  Supabase
   */
/*-------------------------------------------------------*/
  void addNotes() {
    showDialog(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text("Add Note"),
              content: TextField(
                controller: textEditingController,
              ),
              actions: [
                TextButton(
                    onPressed: () {
                      createNote();
                      Navigator.pop(context);
                      textEditingController.clear();
                    },
                    child: const Text("Save")),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                      textEditingController.clear();
                    },
                    child: const Text("Cancel"))
              ],
            ));
  }

/*-------------------------------------------------------*/
  /*
  SAVE/CREATE - A Note in Supabase From App(Experimental)
  */
  /*-------------------------------------------------------*/

  void createNote() async {
    /*Table Name*/
    await Supabase.instance.client
        .from('notes')
        .insert({'body': textEditingController.text});
  }

  /*-------------------------------------------------------*/
  /*
  UPDATE/WIDGET - Notes In Supabase
   */
/*-------------------------------------------------------*/
  void updateNoteDialog(int id, String currentText) {
    textEditingController.text = currentText; // Pre-fill current text
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Update Note"),
        content: TextField(
          controller: textEditingController,
          decoration: const InputDecoration(hintText: "Enter updated note"),
        ),
        actions: [
          TextButton(
            onPressed: () {
              updateNote(id);
              Navigator.pop(context);
            },
            child: const Text("Update"),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              textEditingController.clear();
            },
            child: const Text("Cancel"),
          ),
        ],
      ),
    );
  }

  updateNote(int id) async {
    await Supabase.instance.client
        .from('notes')
        .update({'body': textEditingController.text}).eq('id', id);
  }

/*-------------------------------------------------------*/
  /*
  DELETE - Notes In Supabase
   */
/*-------------------------------------------------------*/
  void deleteNote(int id) async {
    try {
      await Supabase.instance.client.from('notes').delete().eq('id', id);
    } catch (e) {
      print('Error deleting note: $e');
    }
  }

  /*-------------------------------------------------------*/
  /*
  READ - Notes From Supabase in App Using Stream Builder
   */
/*-------------------------------------------------------*/
  final _notesStream =
      Supabase.instance.client.from('notes').stream(primaryKey: ['id']);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Note"),
        actions: [
          IconButton(
              onPressed: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const ProfilePage()));
              },
              icon: const Icon(Icons.account_circle_rounded))
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addNotes();
        },
        child: const Icon(Icons.add),
      ),
      body: LayoutBuilder(builder: (context, BoxConstraints constraints) {
        return StreamBuilder<List<Map<String, dynamic>>>(
            stream: _notesStream,
            builder: (context, snapShot) {
              /*When Loading*/
              if (!snapShot.hasData) {
                return const Center(child: CircularProgressIndicator());
              } else {
                /*When Loaded*/

                final notes = snapShot.data!;
                return ListView.builder(
                    itemCount: notes.length,
                    itemBuilder: (context, index) {
                      // Get Individual Note
                      final note = notes[index];

                      //Get The Column['body']/Name Of The Column, Do You Want Form Supabase

                      final noteText = note['body'];
                      final noteId = note['id'];

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                              title: Text("${index + 1}. $noteText"),
                              trailing: SizedBox(
                                width: 100,
                                child: Row(
                                  children: [
                                    IconButton(
                                        onPressed: () =>
                                            updateNoteDialog(noteId, noteText),
                                        icon: const Icon(Icons.edit)),
                                    IconButton(
                                        onPressed: () => deleteNote(noteId),
                                        icon: const Icon(Icons.delete)),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      );
                    });
              }
            });
      }),
    );
  }
}
