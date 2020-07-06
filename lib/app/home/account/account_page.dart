import 'dart:async';

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
      body: Container(
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
        child: _buildUserInfo(user, context)),
    );
  }

  Widget _buildUserInfo(User user, BuildContext context) {
    return Column(
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
          child: Column(
            children: <Widget>[
              _userDisplayName(user),
              Text('Montreal, QC'),]
        )),
        _condolencesList(),
      ]);
  }

  Widget _userDisplayName(user){
     if (user.displayName != null){
          return Text(
            user.displayName,
            style: TextThemes.title2,
        );
     }else{
       return null;
     }
  }

  Widget _condolencesList(){
    return Container();
  }
}
