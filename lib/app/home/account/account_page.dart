import 'dart:async';

import 'package:intl/intl.dart';
import 'package:thepaper_starter/app/home/account/account_condolence_list_tile.dart';
import 'package:thepaper_starter/app/home/account/account_list_item_builder.dart';
import 'package:thepaper_starter/app/home/jobs/empty_content.dart';
import 'package:thepaper_starter/app/home/models/user_profile.dart';
import 'package:thepaper_starter/common_widgets/avatar.dart';
import 'package:thepaper_starter/common_widgets/platform_alert_dialog.dart';
import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/constants/keys.dart';
import 'package:thepaper_starter/constants/strings.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:thepaper_starter/constants/text_themes.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';
import 'package:thepaper_starter/services/firestore_database.dart';

class AccountPage extends StatelessWidget {
  Future<void> _signOut(BuildContext context) async {
    try {
      final FirebaseAuthService auth =
          Provider.of<FirebaseAuthService>(context, listen: false);
      await auth.signOut();
    } on PlatformException catch (e) {
      await PlatformExceptionAlertDialog(
        title: Strings.logoutFailed,
        exception: e,
      ).show(context);
    }
  }

  Future<void> _confirmSignOut(BuildContext context) async {
    final bool didRequestSignOut = await PlatformAlertDialog(
      title: Strings.logout,
      content: Strings.logoutAreYouSure,
      cancelActionText: Strings.cancel,
      defaultActionText: Strings.logout,
    ).show(context);
    if (didRequestSignOut == true) {
      _signOut(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(Strings.account, style: TextThemes.subtitle),
        elevation: 0.0,
        actions: [
          FlatButton(
            key: Key(Keys.logout),
            child: Text(
              Strings.logout,
              style: TextThemes.logout,
            ),
            onPressed: () => _confirmSignOut(context),
          ),
        ],
      ),
      body: Column(
          children: <Widget>[_buildUserInfo(user, context)]),
    );
  }

  Widget _buildUserInfo(User user, BuildContext context) {
    return Expanded(
      child: SingleChildScrollView(
        physics: ScrollPhysics(),
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Avatar(
                  photoUrl: user.photoUrl,
                  radius: 30,
                  borderColor: Colors.black54,
                  borderWidth: 1.0,
                ),
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: <Widget>[
                      _userDisplayName(user),
                      // Text('Montreal, QC'),
                    ])),
                _condolencesList(context, user),
              ]),
        ),
      ),
    );
  }

  Widget _userDisplayName(user) {
    if (user.displayName != null) {
      return Text(
        user.displayName,
        style: TextThemes.title2,
      );
    } else {
      return null;
    }
  }

  Widget _condolencesList(BuildContext context, User user) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder<UserProfile>(
        stream: database.userProfileStream(uid: user.uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            UserProfile userProfile = snapshot.data;
            if (userProfile != null) {
              // return _buildList(items);
              return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    // _condolenceListHeader(),
                    Container(
                      margin: EdgeInsets.only(top: 20.0, bottom: 20.0),
                      width: double.infinity,
                      decoration: BoxDecoration(
                          border: Border(
                              top: BorderSide(
                        color: Colors.grey,
                        width: 0.3,
                      ))),
                    ),
                    _buildCondolenceList(userProfile.condolences),
                  ]);
            } else {
              return EmptyContent(
                title: "No funerals",
                message: "Check back later for updated schedule",
              );
            }
          } else if (snapshot.hasError) {
            return EmptyContent(
              title: 'Something went wrong',
              message: 'Can\'t load items right now',
            );
          }
          return Center(child: CircularProgressIndicator());
        });
  }

  Widget _condolenceListHeader() {
    return Container(
      decoration: BoxDecoration(
          border: Border(
              top: BorderSide(
        color: Colors.grey,
        width: 0.3,
      ))),
      width: double.infinity,
      margin: EdgeInsets.only(top: 20.0),
      padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
      child: Text('Your Condolences', style: TextThemes.subtitle),
    );
  }

  Widget _buildCondolenceList(List<UserCondolence> condolences) {
    if (condolences.length > 0) {
      condolences.sort((m, m2) => m2.funeralDate.compareTo(m.funeralDate));
      return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          if (index == 0)
            return Container();
          else
            return Divider();
        },
        padding: EdgeInsets.zero, // Top padding of list
        itemCount: condolences.length + 2,
        physics:
            NeverScrollableScrollPhysics(), //: AlwaysScrollableScrollPhysics(),
        shrinkWrap: true, //: false,
        itemBuilder: (context, index) {
          if (index == 0) return Container(); // zero height: not visible
          if (index == condolences.length + 1) {
            return Container(
              margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
            );
          }
          return AccountCondolenceListTile(
              condolence: condolences[index - 1]);
        },
      );
      // return Padding(
      //   padding: const EdgeInsets.only(top: 10.0),
      //   child: Row(
      //       children: <Widget>[
      //         Padding(
      //           padding: const EdgeInsets.only(right: 10.0),
      //           child: Icon(Icons.group, color: Colors.grey),
      //         ),
      //         Row(children:
      //           _funeral.groups.map((item) =>
      //             GestureDetector(
      //               child: new Chip(
      //                 label: Text(item.name),
      //               ),
      //               onTap: () => GroupPage.show(context, groupId: item.id),
      //             )).toList()
      //         )
      //   ]),
      // );
    } else {
      return Container();
    }
  }
}
