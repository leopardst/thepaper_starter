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
  final TextEditingController textEditingController = new TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.condolence != null){
      _name = widget.condolence.name;
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
        final condolence = Condolence(id: id, name: _name, message: _message, updatedAt: updatedAt);
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
      appBar: AppBar(
        title: Text(widget.condolence.name, style: TextThemes.subtitle),
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
    return Column(
      children: <Widget>[
        Expanded(
          flex: 1,
          // constraints: BoxConstraints.expand(),
          child: Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 0.0),
              child: TextField(
                  style: TextStyle(color: Colors.black, fontSize: 15.0),
                  controller: textEditingController,
                  decoration: InputDecoration.collapsed(
                    hintText: 'What do you want to say...',
                    hintStyle: TextStyle(color: Colors.grey),
                  ),
                  autofocus: true,
                  // textInputAction: TextInputAction.newline,
                  // focusNode: focusNode,
          ),
            )),
        ),
      ],    
    );
  }

}

  