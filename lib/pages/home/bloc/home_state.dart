part of 'home_bloc.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

abstract class HomeActionState extends HomeState {}

class HomeLoadingState extends HomeState {}

class HomeSuccessState extends HomeState {
  final List<NoteModel> notes;
  HomeSuccessState({
    required this.notes,
  });
}

class HomeNoteUpdatedSnackBarActionState extends HomeActionState {}

class HomeDeleteNoteSnackBarActionState extends HomeActionState {}

class HomeErrorState extends HomeState {}

class HomeShowBottomSheetActionState extends HomeActionState {}

class HomeNewPostsAddedSuccessfullyActionState extends HomeActionState {}
