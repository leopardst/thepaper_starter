import 'package:flutter/foundation.dart';

class Condolence {
  Condolence({
    @required this.id,
    // @required this.uid,
    @required this.name,
    this.message,
  });

  String id;
  // String uid;
  String name;
  String message;

  factory Condolence.fromMap(Map<dynamic, dynamic> value, String id) {
    return Condolence(
      id: id,
      // uid: value['uid'],
      name: value['name'],
      message: value['message'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      // 'uid': uid,
      'name': name,
      'message': message,
    };
  }
}
