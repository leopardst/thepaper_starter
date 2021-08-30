import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';


class Condolence {
  Condolence({
    required this.id,
    required this.name,
    this.content,
    required this.updatedAt,
    this.userImageURL,
    this.remoteId,
    required this.isPublic,
    this.isDeleted,

  });

  String id;
  String? name;
  String? content;
  DateTime updatedAt;
  String? userImageURL;
  int? remoteId;
  bool? isPublic;
  bool? isDeleted;

  factory Condolence.fromMap(Map<dynamic, dynamic> value, String id) {
    // final int updatedAtAtMilliseconds = value['updatedAt'];
    // print('updatedat' + value['updatedAt'].toString());
    final Timestamp updatedAtTS = value['updatedAt'];
    final deleted = value['isDeleted'] ?? false;

    return Condolence(
      id: id,
      name: value['name'],
      content: value['content'],
      updatedAt: updatedAtTS.toDate(),
      userImageURL: value['userImageURL'],
      isPublic: value['isPublic'],
      remoteId: value['remoteId'],
      isDeleted: deleted,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'content': content,
      'updatedAt': updatedAt,
      'userImageURL': userImageURL,
      'isPublic': isPublic,
      'isDeleted': isDeleted,
    };
  }
}
