// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';

import 'package:traxi/data/auth/auth_repository.dart';
import 'package:traxi/models/user_model.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class UserAuthBloc extends Bloc<UserAuthEvent, UserAuthState> {
  final UserRepository userRepository;

  UserAuthBloc({required this.userRepository}) : super(UserAuthInitial()) {
    // Sign In Event
    on<SignInEvent>((event, emit) async {
      emit(UserAuthLoading());
      try {
        final user = await userRepository.signInWithEmailAndPassword(event.email, event.password);
        if (user != null) {
          emit(UserAuthSuccess(user: UserModel.fromFirebaseUser(user)));
        } else {
          emit(UserAuthFailure(error: 'Failed to sign in'));
        }
      } catch (e) {
        emit(UserAuthFailure(error: e.toString()));
      }
    });

    // Sign Up Event
    on<SignUpEvent>((event, emit) async {
      emit(UserAuthLoading());
      try {
        final user = await userRepository.signUpWithEmailAndPassword(
          event.email,
          event.firstName,
          event.lastName, 
          event.password,
        );
        if (user != null) {
          emit(UserAuthSuccess(user: user));
        } else {
          emit(UserAuthFailure(error: 'Failed to sign up'));
        }
      } catch (e) {
        emit(UserAuthFailure(error: e.toString()));
      }
    });

    // Sign Out Event
    on<SignOutEvent>((event, emit) async {
      emit(UserAuthLoading());
      try {
        await userRepository.signOut();
        emit(UserAuthInitial());
      } catch (e) {
        emit(UserAuthFailure(error: e.toString()));
      }
    });

    // Check Auth Event
    on<CheckAuthEvent>((event, emit) async {
      emit(UserAuthLoading());
      try {
        final firebaseUser = await userRepository.getCurrentUser();
        if (firebaseUser != null) {
          emit(UserAuthSuccess(user: UserModel.fromFirebaseUser(firebaseUser)));
        } else {
          emit(UserAuthFailure(error: 'Failed to authenticate'));
        }
      } catch (e) {
        emit(UserAuthFailure(error: e.toString()));
      }
    });
  }
}
