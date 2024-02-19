// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:bloc_firebase/pages/home/model/note_model.dart';
import 'package:bloc_firebase/pages/home/repo/home_repo.dart';
import 'package:meta/meta.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final homeRepo = HomeRepo();
  HomeBloc() : super(HomeInitial()) {
    on<HomeInitialEvent>(homeInitialEvent);
    on<HomeAddNewNoteEvent>(homeAddNewNote);
    on<HomeAddNewNoteBottomSheetEvent>(homeAddNewNoteBottomSheet);
    on<HomeUpdateNoteEvent>(homeUpdateNoteEvent);
    on<HomeDeleteNoteEvent>(homeDeleteNoteEvent);
  }

  FutureOr<void> homeInitialEvent(
      HomeInitialEvent event, Emitter<HomeState> emit) async {
    // Fetch All the data from firestore
    emit(HomeLoadingState());
    List<NoteModel> notes = await homeRepo.fetchNotes();
    emit(HomeSuccessState(notes: notes));
  }

  FutureOr<void> homeAddNewNote(
      HomeAddNewNoteEvent event, Emitter<HomeState> emit) async {
    await homeRepo.addNote(event.model);
    emit(HomeNewPostsAddedSuccessfullyActionState());
    List<NoteModel> notes = await homeRepo.fetchNotes();
    emit(HomeSuccessState(notes: notes));
  }

  FutureOr<void> homeAddNewNoteBottomSheet(
      HomeAddNewNoteBottomSheetEvent event, Emitter<HomeState> emit) {
    emit(HomeShowBottomSheetActionState());
  }

  FutureOr<void> homeUpdateNoteEvent(
      HomeUpdateNoteEvent event, Emitter<HomeState> emit) async {
    homeRepo.updateNote(
      id: event.model.id,
      title: event.model.title,
      description: event.model.description,
    );
    emit(HomeNoteUpdatedSnackBarActionState());
    emit(HomeSuccessState(notes: await homeRepo.fetchNotes()));
  }

  FutureOr<void> homeDeleteNoteEvent(
      HomeDeleteNoteEvent event, Emitter<HomeState> emit) async{
    homeRepo.deleteNote(event.id);
    emit(HomeDeleteNoteSnackBarActionState());
    emit(HomeSuccessState(notes: await homeRepo.fetchNotes()));
  }
}
