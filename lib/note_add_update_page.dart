import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:simple_notes_app/note.dart';

import 'db_provider.dart';

class NoteAddUpdatePage extends StatefulWidget {
  final Note note;
  NoteAddUpdatePage([this.note]);

  @override
  _NoteAddUpdatePageState createState() => _NoteAddUpdatePageState();
}

class _NoteAddUpdatePageState extends State<NoteAddUpdatePage> {
  TextEditingController _titleController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  bool _isUpdate = false;

  @override
  void initState() {
    super.initState();
    if (widget.note != null) {
      _titleController.text = widget.note.title;
      _descriptionController.text = widget.note.description;
      _isUpdate = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(8.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Judul'
              ),
            ),
            TextField(
              controller: _descriptionController,
              decoration: InputDecoration(
                labelText: 'Deskripsi'
              ),
            ),
            SizedBox(
              width: double.infinity,
              child: RaisedButton(
                child: Text('Simpan'),
                onPressed: () async {
                  if (!_isUpdate) {
                    final note = Note(title: _titleController.text,
                      description: _descriptionController.text);

                    Provider.of<DbProvider>(context, listen:false)
                      .addNote(note);
                  } else {
                    final note = Note(
                      id: widget.note.id,
                      title: _titleController.text,
                      description: _descriptionController.text,
                    );

                    Provider.of<DbProvider>(context, listen: false)
                      .updateNote(note);
                  }

                  Navigator.pop(context);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
