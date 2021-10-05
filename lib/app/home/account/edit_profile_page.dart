import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/app/home/models/comment.dart';
import 'package:thepaper_starter/app/home/models/user_profile.dart';
import 'package:thepaper_starter/routing/router.dart';

import 'package:thepaper_starter/constants/text_themes.dart';
import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/services/analytics_service.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:thepaper_starter/common_widgets/platform_alert_dialog.dart';
import 'package:thepaper_starter/common_widgets/avatar.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';


class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key, required this.userProfile})
    : super(key: key);

  final UserProfile? userProfile;

  static Future<void> show({required BuildContext context, UserProfile? userProfile}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      Routes.editProfilePage,
      arguments: userProfile,
    );
  }

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {

  TextEditingController? nameTextEditingController;
  final _formKey = GlobalKey<FormState>();
  late bool _disableSubmit;

  // TextEditingController locationTextEditingController;

  @override
  void initState() {
    super.initState();
    nameTextEditingController = new TextEditingController(text: widget.userProfile!.displayName);
    _disableSubmit = true;
  }

  Future<void> _saveProfile(BuildContext context) async {

    if (_formKey.currentState!.validate()) {
       _formKey.currentState!.save();
      debugPrint('Saving profile changes');
      String? _oldDisplayName = widget.userProfile!.displayName;

    // if (_content.trim() != '') {
    //   nameTextEditingController.clear();
      try {
        final database = Provider.of<FirestoreDatabase>(context, listen: false);
        // final id = documentIdFromCurrentDate();
        // final updatedAt = DateTime.now();
        // print("url:" + _userImageURL);

        final Map<String, dynamic> userProfileUpdates = {
          'displayName': nameTextEditingController!.text,
        };

        await database.updateUserProfile(userProfileUpdates);

        final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
        analyticsService.logUpdateProfile(_oldDisplayName, nameTextEditingController!.text);
        
        Navigator.of(context).pop();
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    // }
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Edit profile", style: TextThemes.subtitle),
        actions: <Widget>[
          FlatButton(
            textColor: Colors.blue,
            highlightColor: Colors.grey[100],
            // onPressed: null,
            onPressed: _disableSubmit ? null : () => {
              _saveProfile(context)
            },
            child: Text("Save")),
        ],
      ),
      body: _buildContents(context)
    );
     
  }

  Widget _buildContents(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 25.0),
                  child: Text("Name",
                  style: TextThemes.actionTitle,),
                ),
                Expanded(
                  child: TextFormField(
                    decoration: InputDecoration(border: InputBorder.none),
                    controller: nameTextEditingController,
                    style: TextThemes.inputStyle,
                    onChanged: (text) {
                    setState(() {
                      if(text.length>0 && text != widget.userProfile!.displayName)
                        _disableSubmit = false;
                      else
                        _disableSubmit = true;
                      });
                     }
                  ),
                ),
            ]),
            Divider(color: Colors.grey, height: 0.3),

          ],    
        ),
      ),
    );
  }

}

  