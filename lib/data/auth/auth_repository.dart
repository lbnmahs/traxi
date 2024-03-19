import 'package:firebase_auth/firebase_auth.dart';

import 'package:traxi/data/auth/auth_data_provider.dart';
import 'package:traxi/models/user_model.dart';

class UserRepository {
  final UserAuthDataProvider userAuthDataProvider;

  UserRepository(this.userAuthDataProvider);

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    return await userAuthDataProvider.signInWithEmailAndPassword(email, password);
  }

  Future<UserModel?> signUpWithEmailAndPassword(
    String email, String firstName, String lastName, String password
  ) async {
    return await userAuthDataProvider.signUpWithEmailAndPassword(
      email, firstName, lastName, password
    );
  }

  Future<void> signOut() async {
    await userAuthDataProvider.signOut();
  }

  Future<User?> getCurrentUser() async {
    return await userAuthDataProvider.getCurrentUser();
  }
}
