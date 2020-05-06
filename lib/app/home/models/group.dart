import 'package:flutter/foundation.dart';

class GroupFuneral{
  String id;
  String name;

  GroupFuneral.fromMap(Map<dynamic, dynamic> value)
      : id = value["id"],
        name = value["name"];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }
}

class Group {
  Group({
    @required this.id,
    @required this.name,
    @required this.groupFunerals,
    @required this.createdAt,
  });

  String id;
  String name;
  List<GroupFuneral> groupFunerals;
  DateTime createdAt;


  factory Group.fromMap(Map<dynamic, dynamic> value, String id) {
    final int createdAtAtMilliseconds = value['createdAt'];
    return Group(
      id: id,
      name: value['name'],
      groupFunerals: value['groupFunerals'].map<GroupFuneral>((item) {
          return GroupFuneral.fromMap(item);
        }).toList(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtAtMilliseconds),
      // userImageURL: value['userImageURL'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'groupFunerals': groupFunerals,
      'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
