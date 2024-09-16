import 'package:equatable/equatable.dart';
import 'package:eventmanagement/api/ApiResponse.dart';
import 'package:eventmanagement/features/auth/bloc/authentication_bloc.dart';
import 'package:eventmanagement/features/profile/models/profile_model.dart';
import 'package:eventmanagement/services/user_services.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'profile_event.dart';
part 'profile_state.dart';

class ProfileBloc extends HydratedBloc<ProfileEvent, ProfileState> {
  final UserService userService;
  final BuildContext context;

  ProfileBloc(this.context, this.userService) : super(ProfileState.initial()) {
    on<FetchProfileEvent>((event, emit) async {
      // if (state.profileStatus == ProfileStatus.initial) {
      emit(state.copyWith(profileStatus: ProfileStatus.loading));

      if (context.read<AuthenticationBloc>().state
          is AuthenticationAuthenticated) {
        String? accessToken = (context.read<AuthenticationBloc>().state
                as AuthenticationAuthenticated)
            .tokenModel
            .accessToken;

        ApiResponse<UserModel> user =
            await userService.getUserProfile(accessToken);

        if (user.status == 200) {
          if (user.data.address != null) {
            emit(state.copyWith(
              user: user,
              profileAddressStatus: ProfileAddressStatus.fetchSuccess,
              profileStatus: ProfileStatus.fetchSuccess,
            ));
          } else {
            emit(state.copyWith(
              user: user,
              profileStatus: ProfileStatus.fetchSuccess,
            ));
          }
        } else {
          emit(state.copyWith(
            profileStatus: ProfileStatus.fetchFailed,
            user: user,
            profileAddressStatus: ProfileAddressStatus.fetchFailed,
          ));
        }
      }
      // }
    });
  }

  @override
  ProfileState? fromJson(Map<String, dynamic> json) {
    if (json['profile'] != null) {
      return ProfileState(
        user: ApiResponse.fromMap(
          json['profile'],
          (p0) => UserModel.fromJson(p0),
        ),
        profileAddressStatus: ProfileAddressStatus.fetchSuccess,
        profileStatus: ProfileStatus.fetchSuccess,
      );
    }
    return ProfileState.initial();
  }

  @override
  Map<String, dynamic>? toJson(ProfileState state) {
    if (state.profileStatus == ProfileStatus.fetchSuccess ||
        state.profileStatus == ProfileStatus.updateSuccess ||
        state.profileAddressStatus == ProfileAddressStatus.fetchSuccess ||
        state.profileAddressStatus == ProfileAddressStatus.updateSuccess) {
      return {'profile': state.user.toMap((p0) => p0?.toJson())};
    } else {
      return null;
    }
  }
}
