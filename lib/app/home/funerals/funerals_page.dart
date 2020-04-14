import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/app/home/funerals/funeral_list_tile.dart';
import 'package:thepaper_starter/app/home/jobs/list_items_builder.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
// import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/constants/strings.dart';
import 'package:thepaper_starter/services/firestore_database.dart';

class FuneralsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.funerals),
        elevation: 2.0,
      ),
      body: RefreshIndicator(
        child:_buildContents(context),
        onRefresh: () async {},
      )
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder<List<Funeral>>(
      stream: database.funeralsStream(),
      builder: (context, snapshot) {
        return ListItemsBuilder<Funeral>(
          snapshot: snapshot,
          itemBuilder: (context, funeral) => FuneralListTile(
            funeral: funeral,
            ),
        );
      },
    );
  }
}