import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

import 'package:thepaper_starter/app/home/models/comment.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/user_profiles/user_profile_page.dart';
import 'package:thepaper_starter/common_widgets/avatar.dart';
import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/constants/text_themes.dart';

import 'package:thepaper_starter/services/firebase_auth_service.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:thepaper_starter/common_widgets/time_ago_format.dart';

class CondolenceFeedListTile extends StatelessWidget {
  const CondolenceFeedListTile({Key? key, required this.condolence, required this.funeral}) : super(key: key);
  final Condolence condolence;
  final Funeral? funeral;

  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('en_short', CustomEn());
    return Container(
      padding: EdgeInsets.only(bottom: 20.0),
      child: IntrinsicHeight(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(8.0, 0.0, 8.0, 0.0),
            child: Avatar(photoUrl: condolence.userImageURL, radius: 20.0, character: condolence.name![0]),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _nameContent(),
                  _bodyContent(context),
                  Padding(
                    padding: EdgeInsets.only(top: 7.0),
                    child: Wrap(
                      children: <Widget>[
                        Text(
                          timeago.format(condolence.updatedAt, locale: 'en_short'),
                          style: TextThemes.helperText,
                        ),
                        if(condolence.remoteId != null)
                          Text(" · from paperman.com", style: TextThemes.helperText),
                      ]),
                  ),
              ]),
            ),
          ),      
      ],),
    ),
  );

  }
 
  Widget _nameContent(){
     if(condolence.content == null){
      return Wrap(
        children: <Widget>[
          GestureDetector(
            onTap: () => {},
            child: Text(condolence.name!,
              style: TextThemes.subtitle,
            )
          ),
          Text(" left condolences")
        ]);
    } else {
      return GestureDetector(
        onTap: () => {},
        child: Text(condolence.name!,
          style: TextThemes.subtitle,
        )
      );
    }
  }
  Widget _bodyContent(BuildContext context){
    if(condolence.content == null){
      return Container();
    } else {
      return Row(
        children: [
          Expanded(
            child: Text(condolence.content!,
              style: TextThemes.commentBody,
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25.0),
            child: _deleteButton(context),
          ),
        ],
      );
    }
  }

  Widget _deleteButton(BuildContext context){
    final user = Provider.of<AppUser>(context, listen: false);
    if(user.uid == condolence.id){
      return IconButton(
        icon: FaIcon(
          FontAwesomeIcons.times, 
          size: 12.0,
          color: Colors.redAccent,
        ),
        onPressed: () => _removeCondolence(context, funeral!.id),
        padding: EdgeInsets.zero,
        constraints: BoxConstraints(),
      );
    }
    else{
      return Container();
    }
  }

  Future<void> _removeCondolence(
      BuildContext context, String funeralId) async {
    // Navigator.pop(context);

    try {
      final database = Provider.of<FirestoreDatabase>(context, listen: false);
      // final analyticsService =
      //     Provider.of<AnalyticsService>(context, listen: false);

      condolence.isDeleted = true;
      await database.setCondolence(condolence, funeralId, merge: true);

      // analyticsService.logRemoveCondolence(condolence.content, funeralId);
      

    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

}