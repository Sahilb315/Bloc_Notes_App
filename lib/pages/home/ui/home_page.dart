import 'package:bloc_firebase/pages/home/bloc/home_bloc.dart';
import 'package:bloc_firebase/pages/home/model/note_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../repo/home_repo.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    homeBloc.add(HomeInitialEvent());
  }

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final updateTitleController = TextEditingController();
  final updateDescriptionController = TextEditingController();

  final homeBloc = HomeBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('BLOC Notes'),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        shape: const CircleBorder(),
        backgroundColor: Colors.deepPurple.shade200,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
        onPressed: () {
          homeBloc.add(HomeAddNewNoteBottomSheetEvent());
        },
      ),
      bottomNavigationBar: const BottomAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: homeBloc,
        listenWhen: (previous, current) => current is HomeActionState,
        buildWhen: (previous, current) => current is! HomeActionState,
        listener: (context, state) {
          if (state is HomeShowBottomSheetActionState) {
            HomeRepo().addNewNoteSheet(
              title: titleController,
              description: descriptionController,
              context: context,
              homeBloc: homeBloc,
            );
            // }
          } else if (state is HomeNewPostsAddedSuccessfullyActionState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Note Added Successfully"),
              ),
            );
          } else if (state is HomeNoteUpdatedSnackBarActionState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Note Updated Successfully"),
              ),
            );
          } else if (state is HomeDeleteNoteSnackBarActionState) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text("Note Deleted Successfully"),
              ),
            );
          }
        },
        builder: (context, state) {
          switch (state.runtimeType) {
            case HomeLoadingState:
              return Center(
                child: CircularProgressIndicator.adaptive(
                  strokeWidth: 2,
                  backgroundColor: Colors.deepPurple.shade100,
                ),
              );
            case HomeSuccessState:
              final successState = state as HomeSuccessState;
              return ListView.builder(
                itemCount: successState.notes.length,
                itemBuilder: (context, index) {
                  final note = successState.notes[index];
                  return ListTile(
                    title: Text(note.title),
                    subtitle: Text(note.description),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () {
                            updateNoteDialogBox(note);
                          },
                          icon: const Icon(CupertinoIcons.pencil_circle),
                        ),
                        IconButton(
                          onPressed: () {
                            homeBloc.add(HomeDeleteNoteEvent(id: note.id));
                          },
                          icon: const Icon(CupertinoIcons.delete_simple),
                        ),
                      ],
                    ),
                  );
                },
              );
            case HomeErrorState:
              return const Center(
                child: Text("Error"),
              );
            default:
              return const SizedBox();
          }
        },
      ),
    );
  }

  void updateNoteDialogBox(NoteModel note) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog.adaptive(
          title: const Text("Update Note"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: updateTitleController,
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
                controller: updateDescriptionController,
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
                      foregroundColor: const MaterialStatePropertyAll(
                        Colors.white,
                      ),
                    ),
                    onPressed: () {
                      homeBloc.add(
                        HomeUpdateNoteEvent(
                          model: NoteModel(
                            id: note.id,
                            title: updateTitleController.text.isEmpty
                                ? note.title
                                : updateTitleController.text,
                            description:
                                updateDescriptionController.text.isEmpty
                                    ? note.description
                                    : updateDescriptionController.text,
                            postedAt: DateTime.now().toString(),
                          ),
                        ),
                      );
                      Navigator.pop(context);
                      updateDescriptionController.clear();
                      updateTitleController.clear();
                    },
                    child: const Text('Update'),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}
