import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:thepaper_starter/app/home/models/comment.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/condolences/compose_page.dart';
import 'package:thepaper_starter/common_widgets/platform_alert_dialog.dart';
import 'package:thepaper_starter/common_widgets/avatar.dart';

import 'package:thepaper_starter/services/firebase_auth_service.dart';
import 'package:thepaper_starter/services/firestore_database.dart';


class CommentListTile extends StatelessWidget {
  const CommentListTile({Key key, @required this.comment, @required this.funeral}) : super(key: key);
  final Comment comment;
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
            child: Avatar(photoUrl: comment.userImageURL, radius: 20.0),
          ),
          Expanded(
            flex: 1,
            child: Container(
              // decoration: BoxDecoration(
              //   border: Border(
              //     bottom: BorderSide(
              //       color: Colors.grey,
              //       width:0.3,
              //     ),
              //   ),
              // ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Text(comment.name,
                  style: TextStyle(fontWeight: FontWeight.w500),
                  ),
                  Text(comment.content),
                  // _buildSubtitleContent(context, user),
              ]),
            ),
          ),
        ],),
      ),
    );
    // return Padding(
    //   padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
    //   child: ListTile(
    //       leading: Container(
    //       width: 40.0,
    //       height: 40.0,
    //       decoration: BoxDecoration(
    //         shape: BoxShape.circle,
    //       ),
    //       child: CircleAvatar(
    //         child: ClipOval(
    //           child: _buildAvatar(),
    //         ),
    //       ),
    //     ),
    //     title: Text(
    //       condolence.name,
    //     ),
    //     subtitle: _buildSubtitleContent(context, user), 
    //   ),
    // );
  }

  // Widget _buildSubtitleContent(BuildContext context, User user){
   
  //     if(condolence.message != null){
  //       return Text(condolence.message);
  //     } 
  //     else{
  //       if(condolence.id == user.uid){
  //         return GestureDetector(
  //           onTap: () => ComposePage.show(context: context, condolence: condolence, funeral: funeral),
  //           child: Text(
  //             condolence?.message ?? "Add a message...",
  //             style: TextStyle(color: Colors.grey[600]), 
  //           )
  //         );
  //       }
  //       else {
  //         return Container();
  //       }
  //     }
  // }

//   Widget _buildAvatar(){
//     if(condolence.userImageURL != null){
//       return CachedNetworkImage(
//         imageUrl: condolence.userImageURL,
//         height: 50.0,
//         width: 50,
//         fit: BoxFit.cover
//       );
//     } else {
//     return Image(
//       height: 50.0,
//       width: 50.0,
//       image: AssetImage("assets/images/GreenMorty.jpg"), //TODO Replace with placeholder image
//       fit: BoxFit.cover,
//     );
//   }
// }
}