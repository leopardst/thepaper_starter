import 'package:flutter/foundation.dart';

class Comment {
  Comment({
    @required this.id,
    @required this.uid,
    @required this.name,
    @required this.content,
  });

  String id;
  String uid;
  String name;
  String content;

  factory Comment.fromMap(Map<dynamic, dynamic> value, String id) {
    return Comment(
      id: id,
      uid: value['uid'],
      name: value['name'],
      content: value['content'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
      'content': content,
    };
  }
}
