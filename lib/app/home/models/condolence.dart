import 'package:flutter/foundation.dart';

class Condolence {
  Condolence({
    @required this.id,
    @required this.uid,
  });

  String id;
  String uid;

  factory Condolence.fromMap(Map<dynamic, dynamic> value, String id) {
    return Condolence(
      id: id,
      uid: value['uid'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'uid': uid,
    };
  }
}
