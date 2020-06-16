import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:thepaper_starter/app/home/models/comment.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/user_profiles/user_profile_page.dart';
import 'package:thepaper_starter/common_widgets/avatar.dart';
import 'package:thepaper_starter/constants/text_themes.dart';

import 'package:thepaper_starter/services/firebase_auth_service.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:thepaper_starter/common_widgets/time_ago_format.dart';

class CommentListTile extends StatelessWidget {
  const CommentListTile({Key key, @required this.comment, @required this.funeral}) : super(key: key);
  final Comment comment;
  final Funeral funeral;

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
            child: Avatar(photoUrl: comment.userImageURL, radius: 20.0),
          ),
          Expanded(
            flex: 1,
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  GestureDetector(
                    onTap: () => {},
                    child: Text(comment.name,
                      style: TextThemes.subtitle,
                    )
                  ),
                  Text(comment.content,
                    style: TextThemes.commentBody,
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 7.0),
                    child: Wrap(
                      children: <Widget>[
                        Text(
                          timeago.format(comment.createdAt, locale: 'en_short'),
                          style: TextThemes.helperText,
                        ),
                        if(comment.remoteId != null)
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
 
}