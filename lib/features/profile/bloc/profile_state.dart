part of 'profile_bloc.dart';

enum ProfileStatus {
  initial,
  loading,
  fetchSuccess,
  fetchFailed,
  updateSuccess,
  updateFailed,
}

enum ProfileAddressStatus {
  initial,
  loading,
  fetchSuccess,
  fetchFailed,
  updateSuccess,
  updateFailed,
  deleted,
  deleteFailed,
}

class ProfileState extends Equatable {
  final ProfileStatus profileStatus;
  final ProfileAddressStatus profileAddressStatus;
  final ApiResponse<UserModel?> user;

  const ProfileState({
    required this.profileStatus,
    required this.profileAddressStatus,
    required this.user,
  });

  factory ProfileState.initial() {
    return const ProfileState(
      profileStatus: ProfileStatus.initial,
      profileAddressStatus: ProfileAddressStatus.initial,
      user: ApiResponse<UserModel?>(data: null, msg: "", status: 0),
    );
  }

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    ProfileAddressStatus? profileAddressStatus,
    ApiResponse<UserModel?>? user,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      profileAddressStatus: profileAddressStatus ?? this.profileAddressStatus,
      user: user ?? this.user,
    );
  }

  @override
  List<Object?> get props => [profileStatus, profileAddressStatus, user];
}
