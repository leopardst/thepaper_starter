import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/routing/router.gr.dart';
import 'package:thepaper_starter/constants/text_themes.dart';
import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:thepaper_starter/common_widgets/platform_alert_dialog.dart';
import 'package:thepaper_starter/common_widgets/avatar.dart';


class ComposePage extends StatefulWidget {
  const ComposePage({Key key, @required this.condolence, @required this.funeral})
    : super(key: key);
  final Condolence condolence;
  final Funeral funeral;

  static Future<void> show({BuildContext context, Condolence condolence, Funeral funeral}) async {
    await Navigator.of(context, rootNavigator: true).pushNamed(
      Router.composePage,
      arguments: ComposePageArguments(condolence: condolence, funeral: funeral),
    );
  }

  @override
  _ComposePageState createState() => _ComposePageState();
}

class _ComposePageState extends State<ComposePage> {

  String _name;
  String _userImageURL;
  final TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.condolence != null){
      _name = widget.condolence.name;
      _userImageURL = widget.condolence.userImageURL;
    }
  }

  Future<void> _sendMessage(BuildContext context, String _funeralId, String _message) async {
    debugPrint('updating condolence: $widget.condolence');
    if (_message.trim() != '') {
      textEditingController.clear();
      try {
        final database = Provider.of<FirestoreDatabase>(context, listen: false);
        final id = widget.condolence?.id ?? documentIdFromCurrentDate();
        final updatedAt = DateTime.now();
        final condolence = Condolence(id: id, name: _name, message: _message, updatedAt: updatedAt, userImageURL: _userImageURL);
        await database.setCondolence(condolence, _funeralId);
        Navigator.of(context).pop();
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
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Send a message", style: TextThemes.subtitle),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.send, color: Colors.black),
            onPressed: () => _sendMessage(context, widget.funeral.id, textEditingController.text),
          ),
        ],
      ),
      body: _buildContents(context)
    );
     
  }

  Widget _buildContents(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Avatar(photoUrl: widget.condolence.userImageURL, radius: 20.0),
          Expanded(
            flex: 1,
            // constraints: BoxConstraints.expand(),
            child: Container(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
              color: Colors.white,
              child: TextField(
                  maxLines: 50,
                  maxLength: 600,
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  controller: textEditingController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'What do you want to say...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  autofocus: true,
                  textInputAction: TextInputAction.done,
                  onSubmitted: (String str) {
                    _sendMessage(context, widget.funeral.id, str);
                  },
                  // focusNode: focusNode,
            )),
          ),
        ],    
      ),
    );
  }

}

  