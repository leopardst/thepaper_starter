import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/app/home/models/comment.dart';
import 'package:thepaper_starter/routing/router.dart';
import 'package:thepaper_starter/constants/text_themes.dart';
import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/services/analytics_service.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:thepaper_starter/common_widgets/platform_alert_dialog.dart';
import 'package:thepaper_starter/common_widgets/avatar.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';


class CommentField extends StatefulWidget {
  const CommentField({required this.funeral, required this.scrollKey});
  final Funeral? funeral;
  final GlobalKey? scrollKey;

  @override
  _CommentFieldState createState() => _CommentFieldState();
}

class _CommentFieldState extends State<CommentField> {

  String? _name;
  String? _userImageURL;
  final TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    final user = Provider.of<AppUser>(context, listen:false);
    _name = user.displayName ?? user.email;
    _userImageURL = user.photoURL ?? null;
  }

  Future<void> _sendMessage(BuildContext context, String _funeralId, String _content) async {
    FocusScope.of(context).unfocus();
    Scrollable.ensureVisible(widget.scrollKey!.currentContext!);

    debugPrint('Creating condolence' + _content);
    if (_content.trim() != '') {
      textEditingController.clear();
      try {
        final database = Provider.of<FirestoreDatabase>(context, listen: false);
        final id = documentIdFromCurrentDate();
        final updatedAt = DateTime.now();
        print("url:" + _userImageURL!);

        final condolence = Condolence(id: id, name: _name, content: _content, updatedAt: updatedAt, userImageURL: _userImageURL, isPublic: true, isDeleted: false);
        await database.setCondolence(condolence, _funeralId, merge: true);

        final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
        analyticsService.logCreateCondolence(_content, _funeralId);
        
        // Navigator.of(context).pop();
      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        width: 280,
        margin: const EdgeInsets.only(left: 10.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: (Colors.grey[200])!)
        ),
        child: TextField(
          // expands: true,
          maxLines: null,
          // maxLength: 600,
          style: TextThemes.subtitle,
          controller: textEditingController,
          decoration: InputDecoration(
            border:InputBorder.none,
            hintText: 'Add a comment...',
            hintStyle: TextThemes.helperText,
            contentPadding: EdgeInsets.all(15.0),
            isDense: true,
            suffix: GestureDetector(
              onTap: (){
                _sendMessage(context, widget.funeral!.id, textEditingController.text);
              },
              child: Text('Post', style: TextStyle(color: Colors.blueAccent))
            ),
          ),
          // autofocus: true,
          showCursor: true,
          cursorColor: Colors.grey,
          textInputAction: TextInputAction.done,
          onSubmitted: (String str) {
            _sendMessage(context, widget.funeral!.id, str);
          },
          // focusNode: focusNode,
        ),
      ),
    );
  }

  

}

  