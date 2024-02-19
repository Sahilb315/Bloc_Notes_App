import 'dart:developer';

import 'package:bloc_firebase/pages/home/bloc/home_bloc.dart';
import 'package:bloc_firebase/pages/home/model/note_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HomeRepo {
  final firebase = FirebaseFirestore.instance.collection('notes');

  void addNewNoteSheet(
      {required TextEditingController title,
      required TextEditingController description,
      required BuildContext context,
      required HomeBloc homeBloc}) {
    showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) {
        return SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Container(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Add Note",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: title,
                    decoration: InputDecoration(
                      hintText: 'Title',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    controller: description,
                    decoration: InputDecoration(
                      hintText: 'Description',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Colors.deepPurple.shade100,
                          ),
                          foregroundColor:
                              const MaterialStatePropertyAll(Colors.white),
                        ),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: const Text('Cancel'),
                      ),
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStatePropertyAll(
                            Colors.deepPurple.shade100,
                          ),
                          foregroundColor:
                              const MaterialStatePropertyAll(Colors.white),
                        ),
                        onPressed: () async {
                          if (title.text.isNotEmpty &&
                              description.text.isNotEmpty) {
                            homeBloc.add(
                              HomeAddNewNoteEvent(
                                model: NoteModel(
                                  id: "",
                                  title: title.text,
                                  description: description.text,
                                  postedAt: DateTime.now().toString(),
                                ),
                              ),
                            );
                            title.clear();
                            description.clear();
                            log('$title * $description');
                          }
                          Navigator.of(context).pop();
                        },
                        child: const Text('Add'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> addNote(NoteModel noteModel) async {
    await firebase.add({
      'id': '',
      'title': noteModel.title,
      'description': noteModel.description,
      'postedAt': noteModel.postedAt,
    }).then((value) {
      firebase.doc(value.id).update({
        'id': value.id,
      });
    });
  }

  Future<List<NoteModel>> fetchNotes() async {
    final notesFromFirebase = await FirebaseFirestore.instance
        .collection('notes')
        .orderBy('postedAt', descending: true)
        .get();
    return notesFromFirebase.docs
        .map((note) => NoteModel.fromMap(note.data()))
        .toList();
  }

  Future<void> updateNote({
    required String id,
    required String title,
    required String description,
  }) async {
    if (title.isNotEmpty && description.isNotEmpty) {
      await firebase.doc(id).update({
        'title': title,
        'description': description,
      });
    } else if (title.isEmpty) {
      await firebase.doc(id).update({
        'title': title,
      });
    } else {
      await firebase.doc(id).update({
        'description': description,
      });
    }
  }

  Future<void> deleteNote(String id) async {
    await firebase.doc(id).delete();
  }
}
