// ignore_for_file: depend_on_referenced_packages

import 'package:bloc/bloc.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';

import 'package:traxi/data/auth/user_repository.dart';
import 'package:traxi/models/user_model.dart';

part 'user_auth_event.dart';
part 'user_auth_state.dart';

class UserAuthBloc extends Bloc<UserAuthEvent, UserAuthState> {
  final UserRepository userRepository;

  UserAuthBloc(this.userRepository) : super(UserAuthInitial());

  Stream<UserAuthState> authentication(UserAuthEvent event) async* {
    yield UserAuthLoading();
    if(event is CheckAuthEvent) {
      try {
        final firebaseUser = await userRepository.getCurrentUser();
        if (firebaseUser != null) {
          UserModel user = UserModel.fromFirebaseUser(firebaseUser);
          yield UserAuthSuccess(user: user);
        } else {
          yield UserAuthFailure(error: 'Failed to authenticate');
        }
      } catch (e) {
        yield UserAuthFailure(error: e.toString());
      }

    } else if (event is SignInEvent) {
      try {
        User? firebaseUser = await userRepository.signInWithEmailAndPassword( event.email, event.password );
        
        if (firebaseUser != null) {
          UserModel user = UserModel.fromFirebaseUser(firebaseUser);
          yield UserAuthSuccess(user: user);
        } else {
          yield UserAuthFailure(error: 'Failed to sign in');
        }
      } catch (e) {
        yield UserAuthFailure(error: e.toString());
      }

    } else if (event is SignUpEvent) {
      try {
        final user = await userRepository.signUpWithEmailAndPassword(
          event.email,
          event.firstName,
          event.lastName,
          event.password,
        );
        yield UserAuthSuccess(user: user!);
      } catch (e) {
        yield UserAuthFailure(error: e.toString());
      }

    } else if (event is SignOutEvent) {
      try {
        await userRepository.signOut();
        yield UserAuthInitial();
      } catch (e) {
        yield UserAuthFailure(error: e.toString());
      }
      
    } else if (event is SignOutEvent) {
      try {
        await userRepository.signOut();
        yield UserAuthInitial();
      } catch (e) {
        yield UserAuthFailure(error: e.toString());
      }

    }
  }
}
