import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';

class CondolenceListTile extends StatelessWidget {
  const CondolenceListTile({Key key, @required this.condolence, @required this.animation}) : super(key: key);
  final Condolence condolence;
  final Animation<double> animation;


  @override
  Widget build(BuildContext context) {
    // return ListTile(
    //   title: Text(condolence.name),
    //   subtitle: Text("Add a message..."),
    // );
    return Container(
      height: 40.0,
      width: double.infinity,
        margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 0.3,
              )
          ),
          // color: Colors.blue,
          // borderRadius: BorderRadius.circular(20.0),
        ),
      child: Text(condolence.name),
    );
  }
}
