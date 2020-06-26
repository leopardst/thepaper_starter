import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/condolences/compose_page.dart';
import 'package:thepaper_starter/common_widgets/platform_alert_dialog.dart';
import 'package:thepaper_starter/common_widgets/avatar.dart';
import 'package:thepaper_starter/constants/text_themes.dart';

import 'package:thepaper_starter/services/firebase_auth_service.dart';
import 'package:thepaper_starter/services/firestore_database.dart';

class CondolenceListTile extends StatelessWidget {
  const CondolenceListTile({Key key, @required this.condolence, @required this.funeral}) : super(key: key);
  final Condolence condolence;
  final Funeral funeral;

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Container(
      padding: EdgeInsets.only(bottom: 20.0),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            child: Avatar(photoUrl: condolence.userImageURL, radius: 20.0, character: condolence.name[0]),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(condolence.name,
                  style: TextThemes.actionTitle,
                  ),
              ]),
            ),
          ),
        ],),
      ),
    );

  }


}