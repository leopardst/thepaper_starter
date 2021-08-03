import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/app/home/models/comment.dart';

import 'package:thepaper_starter/constants/text_themes.dart';
import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/routing/router.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:thepaper_starter/common_widgets/platform_alert_dialog.dart';
import 'package:thepaper_starter/common_widgets/avatar.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';


class CondolencesPage extends StatefulWidget {
  const CondolencesPage({Key key, @required this.funeral})
    : super(key: key);
  final Funeral funeral;

  static Future<void> show({BuildContext context, Funeral funeral}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      Routes.composePage,
      arguments: {funeral: funeral},
    );
  }

  @override
  _CondolencesPageState createState() => _CondolencesPageState();
}

class _CondolencesPageState extends State<CondolencesPage> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
    );
     
  }



}

  