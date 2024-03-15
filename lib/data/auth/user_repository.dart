import 'package:firebase_auth/firebase_auth.dart';

import 'package:traxi/data/auth/user_data_provider.dart';
import 'package:traxi/models/user_model.dart';

class UserRepository {
  final UserAuthDataProvider _userAuthDataProvider;

  UserRepository(this._userAuthDataProvider);

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    return await _userAuthDataProvider.signInWithEmailAndPassword( email, password);
  }

  Future<UserModel?> signUpWithEmailAndPassword(
    String email, String firstName, String lastName, String password
  ) async {
    return await _userAuthDataProvider.signUpWithEmailAndPassword(
      email, firstName, lastName, password
    );
  }

  Future<void> signOut() async {
    await _userAuthDataProvider.signOut();
  }

  Future<User?> getCurrentUser() async {
    return await _userAuthDataProvider.getCurrentUser();
  }
}
