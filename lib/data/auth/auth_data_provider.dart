import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:traxi/models/user_model.dart';

class UserAuthDataProvider {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

  // Sign in with email and password
  Future<User?> signInWithEmailAndPassword( String email, String password ) async {
    try {
      UserCredential userCredential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(), password: password,
      );
      return userCredential.user;
    } on FirebaseAuthException catch (e) {
      // Handling specific error codes
      switch (e.code) {
        case 'user-not-found':
          throw Exception('No user found for that email');
        case 'wrong-password':
          throw Exception('Wrong password provided for that user');
        default:
          throw Exception('An error occurred: ${e.code}');
      }
    } catch (e) {
      // Handle any other exceptions
      debugPrint('An unexpected error occurred: $e');
      return null;
    }
  }

  // Sign up with email and password
  Future<UserModel?> signUpWithEmailAndPassword(
    String email, String firstName, String lastName, String password
  ) async {
    if (!isPasswordStrong(password)) {
      throw Exception('The provided password is not strong enough');
    }
    try {
      debugPrint('Signing up with email: $email');
      UserCredential userCredential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(), password: password
      );
      User? user = userCredential.user;
      if (user != null) {
        await user.updateDisplayName('$firstName $lastName');
        await FirebaseFirestore.instance.collection('users').doc(user.uid).set({
          'firstName': firstName,
          'lastName': lastName,
          'email': email,
          'createdAt': FieldValue.serverTimestamp(),
        });
        return UserModel(
          uid: user.uid,
          email: user.email!,
          firstName: firstName,
          lastName: lastName,
        );
      }
      return null;
    } on FirebaseAuthException catch (e) {
      switch (e.code) {
        case 'email-already-in-use':
          throw Exception('The provided email is already in use');
        case 'invalid-email':
          throw Exception('The provided email is invalid');
        default:
          throw Exception('An error occurred: ${e.code}');
      }
    } catch (e) {
      throw Exception('An unexpected error occurred: $e');
    }
  }
  bool isPasswordStrong(String password) {
    // Check if password meets your requirements
    // This is just an example, adjust the rules to fit your needs
    return password.length >= 6 &&
      password.contains(RegExp(r'[A-Z]')) &&
      password.contains(RegExp(r'[a-z]')) &&
      password.contains(RegExp(r'[0-9]')) &&
      password.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'));
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }

  Future<User?> getCurrentUser() async {
    return _firebaseAuth.currentUser;
  }
}