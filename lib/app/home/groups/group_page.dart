import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/app/home/jobs/list_items_builder.dart';
import 'package:thepaper_starter/app/home/models/group.dart';
import 'package:thepaper_starter/constants/text_themes.dart';
import 'package:thepaper_starter/routing/cupertino_tab_view_router.dart';
import 'package:thepaper_starter/services/firestore_database.dart';

class GroupPage extends StatelessWidget {
  const GroupPage({required this.group});
  final Group? group;

  static Future<void> show(BuildContext context,
      {Group? group, String? groupId}) async {
    Group? _group;
    final database = Provider.of<FirestoreDatabase>(context, listen: false);

    if (groupId != null) {
      _group = await database.groupStream(groupId: groupId).first;
    } else if (group != null) {
      _group = group;
    }

    await Navigator.of(context).pushNamed(
      CupertinoTabViewRoutes.groupPage,
      arguments: _group,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(children: <Widget>[
      Padding(
        padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.arrow_back),
              iconSize: 30.0,
              color: Colors.black,
              onPressed: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
      Expanded(
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(children: <Widget>[
            Text(group!.name!, style: TextThemes.title),
            RaisedButton(
              onPressed: () => {},
              child: Text("Follow"),
            ),
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.only(right: 10.0),
                    child: Icon(Icons.location_on, color: Colors.grey),
                  ),
                  Flexible(child: Text("${group!.type} in ${group!.city}, ${group!.state}")),
                ]),
            buildFuneralList(context),
          ]),
        ),
      ),
    ]));
  }

  Widget buildFuneralList(BuildContext context) {
    return ListView.separated(
        separatorBuilder: (context, index) => Divider(color: Colors.black),
        itemCount: group!.groupFunerals!.length,
        shrinkWrap: true, 
        physics: NeverScrollableScrollPhysics(),
        itemBuilder: (BuildContext ctx, int index) {
          return ListTile(
            title: Text(group!.groupFunerals![index].name!),
          );
        });
  }
}
