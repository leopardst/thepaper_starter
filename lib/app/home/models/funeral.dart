import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

class Funeral {
  Funeral({
    @required this.id,
    @required this.name,
    @required this.date,
  });

  String id;
  String name;
  DateTime date;

  factory Funeral.fromMap(Map<dynamic, dynamic> value, String id) {
    final Timestamp dateTS = value['date'];
    return Funeral(
      id: id,
      name: value['name'],
      date: dateTS.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'date': date.millisecondsSinceEpoch,
    };
  }
}
