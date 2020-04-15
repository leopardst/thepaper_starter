import 'package:flutter/foundation.dart';

class Condolence {
  Condolence({
    @required this.id,
    @required this.uid,
    @required this.name,
  });

  String id;
  String uid;
  String name;

  factory Condolence.fromMap(Map<dynamic, dynamic> value, String id) {
    return Condolence(
      id: id,
      uid: value['uid'],
      name: value['name'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
      'name': name,
    };
  }
}
