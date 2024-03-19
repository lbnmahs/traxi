part of 'auth_bloc.dart';

@immutable
sealed class UserAuthEvent {}

class SignInEvent extends UserAuthEvent {
  final String email;
  final String password;

  SignInEvent({required this.email, required this.password});
}

class SignUpEvent extends UserAuthEvent {
  final String email;
  final String firstName;
  final String lastName;
  final String password;

  SignUpEvent({
    required this.email, 
    required this.firstName, 
    required this.lastName, 
    required this.password
  });
}

class SignOutEvent extends UserAuthEvent {}

class CheckAuthEvent extends UserAuthEvent {}