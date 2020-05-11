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
import 'package:google_fonts/google_fonts.dart';
import 'package:thepaper_starter/routing/router.gr.dart';
import 'package:thepaper_starter/app/home/condolences/condolences_list_builder.dart';

class CondolencesPage extends StatelessWidget{
  const CondolencesPage({Key key, @required this.funeral})
    : super(key: key);
  final Funeral funeral;

  static Future<void> show({BuildContext context, Funeral funeral}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      Router.condolencesPage,
      arguments: CondolencesPageArguments(funeral: funeral),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
       appBar: AppBar(
        title: Text("Condolences"),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => Navigator.of(context).pop(),

          ),
        ],
      ),
      body: CondolencesListBuilder(funeral: funeral),
    );
  }
}