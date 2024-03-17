part of 'auth_bloc.dart';

@immutable
sealed class UserAuthEvent {}

class SignInEvent extends UserAuthEvent {
  final String email;
  final String password;

  SignInEvent(this.email, this.password);
}

class SignUpEvent extends UserAuthEvent {
  final String email;
  final String firstName;
  final String lastName;
  final String password;

  SignUpEvent(this.email, this.firstName, this.lastName, this.password);
}

class SignOutEvent extends UserAuthEvent {}

class CheckAuthEvent extends UserAuthEvent {}