import 'package:flutter/foundation.dart';

class GroupFuneral{
  String? id;
  String? name;

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
    required this.id,
    required this.name,
    required this.groupFunerals,
    required this.type,
    required this.city,
    required this.state,
    // @required this.createdAt,
  });

  String id;
  String? name;
  String? type;
  String? city;
  String? state;
  List<GroupFuneral>? groupFunerals;
  // DateTime createdAt;

  factory Group.fromMap(Map<dynamic, dynamic> value, String id) {
    // final int createdAtAtMilliseconds = value['createdAt'];
    return Group(
      id: id,
      name: value['name'],
      city: value['city'],
      state: value['state'],
      type: value['type'],
      groupFunerals: value['group_funerals'].map<GroupFuneral>((item) {
          return GroupFuneral.fromMap(item);
        }).toList(),
      // createdAt: DateTime.fromMillisecondsSinceEpoch(createdAtAtMilliseconds),
      // userImageURL: value['userImageURL'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      // 'group_funerals': groupFunerals,
      // 'createdAt': createdAt.millisecondsSinceEpoch,
    };
  }
}
