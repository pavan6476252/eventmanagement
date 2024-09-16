import 'dart:developer';

import 'package:eventmanagement/api/ApiResponse.dart';
import 'package:eventmanagement/features/auth/models/TokenModel.dart';
import 'package:eventmanagement/services/authentication_ser.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends HydratedBloc<AuthenticationEvent, AuthenticationState> {
  final AuthenticationService authService;
  final BuildContext context;

  AuthenticationBloc(this.context, this.authService)
      : super(AuthenticationInitial()) {
    on<SignupEvent>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        String? firebaseToken =
            await FirebaseAuth.instance.currentUser?.getIdToken();
        if (firebaseToken == null) throw Exception('No firebase token found');
        ApiResponse<Null> response = await authService.signup(firebaseToken);

        if (response.status == 200) {
          emit(AuthenticationSuccess(response.msg));
        } else {
          emit(AuthenticationError(response.msg));
        }
      } catch (e) {
        log(e.toString());
        emit(AuthenticationError(e.toString()));
      }
    });

    on<LoginEvent>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        String? firebaseToken =
            await FirebaseAuth.instance.currentUser?.getIdToken();
        log(firebaseToken.toString());
        if (firebaseToken == null) throw Exception('No firebase token found');
        ApiResponse<TokenModel?> response =
            await authService.login(firebaseToken);
        if (response.data != null) {
          emit(AuthenticationAuthenticated(response.data!));
        } else {
          emit(AuthenticationError(response.msg));
        }
      } catch (e) {
        emit(AuthenticationError(e.toString()));
      }
    });

    on<LogoutEvent>((event, emit) async {
      emit(AuthenticationLoading());
      try {
        ApiResponse<Null> response =
            await authService.logout(event.accessToken);
        if (response.status == 200) {
          await FirebaseAuth.instance.signOut();
          await GoogleSignIn().signOut();
          emit(AuthenticationUnauthenticated());
        } else {
          emit(AuthenticationError(response.msg));
        }
      } catch (e) {
        emit(AuthenticationError(e.toString()));
      }
    });

    on<NewTokensEvent>((event, emit) async {
      emit(AuthenticationAuthenticated(event.tokenModel));
    });
  }

  @override
  AuthenticationState? fromJson(Map<String, dynamic> json) {
    if (json['tokens'] != null) {
      return AuthenticationAuthenticated(TokenModel.fromMap(json['tokens']));
    }
    return AuthenticationInitial();
  }

  @override
  Map<String, dynamic>? toJson(AuthenticationState state) {
    if (state is AuthenticationUnauthenticated) {
      return {};
    }
    if (state is AuthenticationAuthenticated) {
      return {'tokens': state.tokenModel.toMap()};
    }
    return null;
  }
}
