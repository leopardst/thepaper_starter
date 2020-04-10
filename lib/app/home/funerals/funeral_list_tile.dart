
import 'package:flutter/material.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';

class FuneralListTile extends StatelessWidget {
  const FuneralListTile({Key key, @required this.funeral}) : super(key: key);
  final Funeral funeral;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(funeral.name),
      trailing: Icon(Icons.chevron_right),
    );
  }
}
