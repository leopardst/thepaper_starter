import 'package:flutter/foundation.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Comment {
  Comment({
    @required this.id,
    @required this.name,
    @required this.content,
    @required this.createdAt,
    @required this.userImageURL,
    this.isPublic,
    this.remoteId,
  });

  String id;
  String name;
  String content;
  DateTime createdAt;
  String userImageURL;
  bool isPublic;
  int remoteId;

  factory Comment.fromMap(Map<dynamic, dynamic> value, String id) {
    final Timestamp createdAtTS = value['createdAt'];

    return Comment(
      id: id,
      name: value['name'],
      content: value['content'],
      createdAt: createdAtTS.toDate(),
      userImageURL: value['userImageURL'],
      isPublic: value['isPublic'],
      remoteId: value['remoteId'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'content': content,
      'createdAt': createdAt,
      'userImageURL': userImageURL,
    };
  }
}
