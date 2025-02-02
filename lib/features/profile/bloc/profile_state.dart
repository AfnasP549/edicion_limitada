part of 'profile_bloc.dart';

sealed class ProfileState extends Equatable {
  const ProfileState();
  
  @override
  List<Object> get props => [];
}

final class ProfileInitial extends ProfileState {}

class ProfileLoadingState extends ProfileState{}

class ProfileLoadedState extends ProfileState{
  final UserModel user;

  const ProfileLoadedState(this.user);
}

class ProfileUpdatedState extends ProfileState{}

class ProfileErrorState extends ProfileState{
  final String message;

  const ProfileErrorState(this.message);
}


class ProfileImagePickedState extends ProfileState {
  final String imagePath;
  final String base64Image;
  const ProfileImagePickedState(this.imagePath, this.base64Image);
}
