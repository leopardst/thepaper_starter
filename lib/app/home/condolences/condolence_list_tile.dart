import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';

class CondolenceListTile extends StatelessWidget {
  const CondolenceListTile({Key key, @required this.condolence }) : super(key: key);
  final Condolence condolence;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(condolence.uid),
    );
  }
}
