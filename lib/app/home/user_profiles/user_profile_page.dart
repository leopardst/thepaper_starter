import 'dart:async';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:thepaper_starter/app/home/models/comment.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/app/home/models/user_profile.dart';
import 'package:thepaper_starter/common_widgets/avatar.dart';
import 'package:thepaper_starter/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/routing/cupertino_tab_view_router.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:thepaper_starter/common_widgets/platform_alert_dialog.dart';
import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({this.userProfile});
  final UserProfile? userProfile;

  static Future<void> show(BuildContext context, {String? uid, Comment? comment, Condolence? condolence}) async {

    var userProfile;

    // if(uid != null){
    //   final database = Provider.of<FirestoreDatabase>(context, listen: false);
    //   userProfile = await database.jobsStream().first;
    // }else if(comment != null){
       
    // }else if(condolence != null){

    // }
    
    await Navigator.of(context).pushNamed(
      CupertinoTabViewRoutes.userProfilePage,
      arguments: userProfile,
    );

  }     
     
  @override
  Widget build(BuildContext context) {
    
    return _buildUserInfo(userProfile!);
    
    //final database = Provider.of<FirestoreDatabase>(context, listen: false);
    // return StreamBuilder<UserProfile>(
    //   stream: database.userProfileStream(uid: uid),
    //   builder: (context, snapshot) {
    //     switch (snapshot.connectionState) {
    //       case ConnectionState.waiting: return Center(child: CircularProgressIndicator(backgroundColor: Colors.amber,strokeWidth: 1));
    //       default:
    //         if(snapshot.hasData){
    //           // final userProfile = snapshot.data;
    //           // return _buildUserInfo(userProfile);
    //         }
    //         else if(!snapshot.hasData){              
    //           return Center(child: Text('This user does not exist'));
    //         }
    //         else if(snapshot.hasError){
    //           return Text('Error: ${snapshot.error}');
    //         }
    //     }
    //     return null;
    //   }
    // );
  }

  Widget _buildUserInfo(UserProfile userProfile) {
    return Scaffold(
      appBar: AppBar(
        title: Text(userProfile.displayName!),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(130.0),
          child: Column(
            children: [
              Avatar(
                photoUrl: userProfile.photoURL,
                radius: 50,
                borderColor: Colors.black54,
                borderWidth: 1.0,
              ),
              SizedBox(height: 8),
              if (userProfile.displayName != null)
                Text(
                  userProfile.displayName!,
                  style: TextStyle(color: Colors.black),
                ),
              SizedBox(height: 8),
            ],
          ),
        ),
      ));    
  }
}