import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserCondolence{
  String id;
  String name;
  String imageURL;
  DateTime funeralDate;

  UserCondolence.fromMap(Map<dynamic, dynamic> value)
      : id = value["id"],
        name = value["name"],
        imageURL = value["imageURL"],
        funeralDate = value["funeralDate"].toDate();
}


class UserProfile {
  UserProfile({
    @required this.id,
    @required this.displayName,
    @required this.createdDate,
    @required this.email,
    @required this.photoURL,
    this.condolences,
    // @required this.phoneNumber,
  });

  String id;
  String displayName;
  DateTime createdDate;
  String email;
  String photoURL;
  List<UserCondolence> condolences;

  // String phoneNumber;

  factory UserProfile.fromMap(Map<dynamic, dynamic> value, String id) {
    final Timestamp createdDateTS = value['createdDate'];

    var _ucList;
    List<UserCondolence> finalUCList = [];

    if (value["condolences"]?.isEmpty ?? true) {
      finalUCList = [];
    }else{
        _ucList = value['condolences'].map((item) {
        var z = Map<String, dynamic>.from(item);
        // print(z['name']);
        return UserCondolence.fromMap(z);
      }).toList();
      print(_ucList.toString());
      finalUCList = List<UserCondolence>.from(_ucList);
    }
    
    return UserProfile(
      id: id,
      displayName: value['displayName'],
      email: value['email'],
      createdDate: createdDateTS.toDate(),
      photoURL: value['photoURL'],
      condolences: finalUCList,
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
