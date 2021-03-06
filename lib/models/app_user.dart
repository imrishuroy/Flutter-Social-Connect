import 'package:cloud_firestore/cloud_firestore.dart';

class AppUser {
  final String id;
  final String username;
  final String email;
  final String displayName;
  final String bio;
  final String photoUrl;

  AppUser({
    this.id,
    this.username,
    this.email,
    this.displayName,
    this.bio,
    this.photoUrl,
  });

  // serializing our own object from firebase user class
  factory AppUser.fromDocument(DocumentSnapshot doc) {
    return AppUser(
      id: doc['id'],
      email: doc['email'],
      displayName: doc['displayName'],
      photoUrl: doc['photoUrl'],
      bio: doc['bio'],
      username: doc['username'],
    );
  }
}
