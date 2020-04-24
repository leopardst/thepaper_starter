import 'package:flutter/foundation.dart';

class Condolence {
  Condolence({
    @required this.id,
    @required this.name,
    this.message,
    @required this.updatedAt,
  });

  String id;
  String name;
  String message;
  DateTime updatedAt;


  factory Condolence.fromMap(Map<dynamic, dynamic> value, String id) {
    final int updatedAtAtMilliseconds = value['updatedAt'];
    return Condolence(
      id: id,
      name: value['name'],
      message: value['message'],
      updatedAt: DateTime.fromMillisecondsSinceEpoch(updatedAtAtMilliseconds),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'message': message,
      'updatedAt': updatedAt.millisecondsSinceEpoch,

    };
  }
}
