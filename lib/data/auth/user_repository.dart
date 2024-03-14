import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:traxi/data/auth/user_data_provider.dart';
import 'package:traxi/models/user_model.dart';

class UserRepository {
  final UserAuthDataProvider _userAuthDataProvider;

  UserRepository(this._userAuthDataProvider);

  // Sign Up
  Future<UserModel?> signUpWithEmailAndPassword (
    String email, String firstName, String lastName, String password
  ) async {
    return await _userAuthDataProvider.signUpWithEmailAndPassword(
      email, firstName, lastName, password
    );
  }

  // Sign In
  Future<UserModel?> signInWithEmailAndPassword (
    String email, String password
  ) async {
    try {
      User? user = await _userAuthDataProvider.signInWithEmailAndPassword(email, password);
      if(user?.email != null) {
        String firstName = 'Example'; // Replace with actual first name
        String lastName = 'User'; // Replace with actual last name
        return UserModel(
          uid: user?.uid ?? '',
          email: user?.email! ?? '',
          firstName: firstName,
          lastName: lastName,
        );
      }
      return null;
    } catch (e) {
      debugPrint('An error occurred during sign-in: $e');
      return null;
    }
  }
}
