part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class LoadProfile extends ProfileEvent{
  final String uid;

  const LoadProfile(this.uid);
}

class UpdateProfile extends ProfileEvent{
  final UserModel user;
  final DateTime selectedDate;

  const UpdateProfile(this.user, this.selectedDate);
}

class ResetProfile extends ProfileEvent{
  const ResetProfile();
}


class PickProfileImage extends ProfileEvent{}

class UpdateProfileImage extends ProfileEvent{
  final String imagePath;

  const UpdateProfileImage(this.imagePath);
}