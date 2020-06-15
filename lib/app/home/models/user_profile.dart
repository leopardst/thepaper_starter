import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProfile {
  UserProfile({
    @required this.id,
    @required this.displayName,
    @required this.createdDate,
    @required this.email,
    @required this.photoURL,
    // @required this.phoneNumber,
  });

  String id;
  String displayName;
  DateTime createdDate;
  String email;
  String photoURL;
  // String phoneNumber;

  factory UserProfile.fromMap(Map<dynamic, dynamic> value, String id) {
    final Timestamp createdDateTS = value['createdDate'];

    return UserProfile(
      id: id,
      displayName: value['displayName'],
      email: value['email'],
      createdDate: createdDateTS.toDate(),
      photoURL: value['photoURL'],
      // phoneNumber: value['phoneNumber'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'displayName': displayName,
      'email': email,
      'createdDate': createdDate,
      'photoURL': photoURL,
    };
  }
}
