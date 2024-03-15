import 'package:firebase_auth/firebase_auth.dart';

class UserModel {
  final String uid;
  final String email;
  final String firstName;
  final String lastName;
  final String? profilePhoto;

  UserModel({
    required this.uid,
    required this.email,
    required this.firstName,
    required this.lastName,
    this.profilePhoto,
  });
  
  factory UserModel.fromFirebaseUser(User user) {
    return UserModel(
      uid: user.uid,
      email: user.email!,
      firstName: user.displayName!.split(' ')[0],
      lastName: user.displayName!.split(' ')[1],
      profilePhoto: user.photoURL,
    );
  }
}
