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
}
