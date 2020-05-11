import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Condolence {
  Condolence({
    @required this.id,
    @required this.name,
    this.message,
    @required this.updatedAt,
    this.userImageURL,
  });

  String id;
  String name;
  String message;
  DateTime updatedAt;
  String userImageURL;


  factory Condolence.fromMap(Map<dynamic, dynamic> value, String id) {
    // final int updatedAtAtMilliseconds = value['updatedAt'];
    // print('updatedat' + value['updatedAt'].toString());
    final Timestamp updatedAtTS = value['updatedAt'];

    return Condolence(
      id: id,
      name: value['name'],
      message: value['message'],
      updatedAt: updatedAtTS.toDate(),
      userImageURL: value['userImageURL'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'message': message,
      'updatedAt': updatedAt,
      'userImageURL': userImageURL,
    };
  }
}
