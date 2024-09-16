part of 'profile_bloc.dart';

sealed class ProfileEvent extends Equatable {
  const ProfileEvent();

  @override
  List<Object> get props => [];
}

class FetchProfileEvent extends ProfileEvent {}

class UpdateProfileEvent extends ProfileEvent {}

class CreateProfileAddressEvent extends ProfileEvent {}

class UpdateProfileAddressEvent extends ProfileEvent {}

class DeleteProfileAddressEvent extends ProfileEvent {}
