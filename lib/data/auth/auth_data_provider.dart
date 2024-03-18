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
        case 'email-already-in-use':
          debugPrint('The provided email is already in use');
          break;
        case 'weak-password':
          debugPrint('The provided password is too weak');
          break;
        case 'user-not-found':
          debugPrint('No user found for that email');
          break;
        case 'wrong-password':
          debugPrint('Wrong password provided for that user');
          break;
        default:
          debugPrint('An error occurred: ${e.code}');
      }
      return null;
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
        case 'operation-not-allowed':
          throw Exception('Email/password accounts are not enabled');
        default:
          throw Exception('An error occurred: ${e.code}');
      }
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