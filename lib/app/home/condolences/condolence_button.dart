import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:thepaper_starter/routing/router.gr.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';

class CondolenceButton extends StatefulWidget {
  const CondolenceButton({@required this.funeral});
  final Funeral funeral;

  @override
  State<StatefulWidget> createState() => _CondolenceButtonState();
}

class _CondolenceButtonState extends State<CondolenceButton> {
  bool isLiked = false; // Has sent condolences

  @override
  void initState() {
    super.initState();
  }

  Condolence _condolenceFromState() {
    final user = Provider.of<User>(context, listen:false);
    // final uid = user.uid;
    final name = user.email;
    final id = documentIdFromCurrentDate();
      
    return Condolence(
      id: id,
      // uid: uid,
      name: name,
    );
  }


  Future<void> _toggleCondolence(BuildContext context, String funeralId, bool isLiked) async {
    try {
      final database = Provider.of<FirestoreDatabase>(context, listen: false);
      if(isLiked){
        await database.deleteCondolence(funeralId);
      }else{
        final condolence = _condolenceFromState();
        await database.setCondolence(condolence, funeralId);
      }
      setState(() {
        isLiked = !isLiked;
      });
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder(
      stream: database.condolenceStream(funeralId: widget.funeral.id),
      builder: (context, snapshot){
        if(snapshot.data != null){
          isLiked = true;
        } else{
          isLiked = false;
        }
        return Row(
          children: <Widget>[
          IconButton(
            padding: EdgeInsets.fromLTRB(0.0, 8.0, 8.0, 8.0),
            icon: Icon(
              isLiked ? Icons.favorite : Icons.favorite_border,
              color: isLiked ? Colors.red : Colors.grey 
            ), 
            onPressed: () => _toggleCondolence(context, widget.funeral.id, isLiked),
          ),
          Text("Condolences")

        ],);
        

      }
    );
  }
}