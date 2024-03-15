part of 'user_auth_bloc.dart';

@immutable
sealed class UserAuthState {}

final class UserAuthInitial extends UserAuthState {}

final class UserAuthLoading extends UserAuthState {}

final class UserAuthSuccess extends UserAuthState {
  final UserModel user;

  UserAuthSuccess({required this.user});
}

final class UserAuthFailure extends UserAuthState {
  final String error;

  UserAuthFailure({required this.error});
}
