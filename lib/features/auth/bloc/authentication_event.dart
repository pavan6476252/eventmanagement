part of 'authentication_bloc.dart';

@immutable
sealed class AuthenticationEvent {}

final class SignupEvent extends AuthenticationEvent {
  final String role;
  SignupEvent(this.role);
}

final class LoginEvent extends AuthenticationEvent {}

final class LogoutEvent extends AuthenticationEvent {
  final String accessToken;
  LogoutEvent(this.accessToken);
}

final class NewTokensEvent extends AuthenticationEvent {
  final TokenModel tokenModel;
  NewTokensEvent(this.tokenModel);
}
