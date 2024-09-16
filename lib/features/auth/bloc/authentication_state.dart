part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationState {}

final class AuthenticationInitial extends AuthenticationState {}

final class AuthenticationLoading extends AuthenticationState {}

final class AuthenticationAuthenticated extends AuthenticationState {
  final TokenModel tokenModel;
  AuthenticationAuthenticated(this.tokenModel);
}

final class AuthenticationUnauthenticated extends AuthenticationState {}

final class AuthenticationSuccess extends AuthenticationState {
  final String message;
  AuthenticationSuccess(this.message);
}

final class AuthenticationError extends AuthenticationState {
  final String message;
  AuthenticationError(this.message);
}
