part of 'home_bloc.dart';

@immutable
sealed class HomeEvent {}

class HomeInitialEvent extends HomeEvent {}

class HomeAddNewNoteEvent extends HomeEvent {
  final NoteModel model;

  HomeAddNewNoteEvent({required this.model});
}

class HomeAddNewNoteBottomSheetEvent extends HomeEvent {}

class HomeUpdateNoteEvent extends HomeEvent {
  final NoteModel model;

  HomeUpdateNoteEvent({required this.model});
}

class HomeDeleteNoteEvent extends HomeEvent {
  final String id;

  HomeDeleteNoteEvent({required this.id});
}
