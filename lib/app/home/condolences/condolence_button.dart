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
import 'package:thepaper_starter/app/home/condolences/compose_page.dart';
import 'package:thepaper_starter/common_widgets/icomoon_icons.dart';


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
    final name = user.displayName ?? user.email;
    final id = documentIdFromCurrentDate();
    final updatedAt = DateTime.now();
    final userImageURL = user.photoUrl ?? null;

    return Condolence(
      id: id,
      name: name,
      updatedAt: updatedAt,
      userImageURL: userImageURL,
    );
  }


  Future<void> _toggleCondolence(BuildContext context, String funeralId, bool isLiked) async {
    Navigator.pop(context);
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
        return Container(
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(
                color: Colors.grey,
                width: 0.3,
              ),
              bottom: BorderSide(
                color: Colors.grey,
                width: 0.3,
              ))
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: Row(
                children: <Widget>[
                  IconButton(
                    // padding: EdgeInsets.fromLTRB(0.0, 8.0, 0.0, 8.0),
                    icon: Icon(
                      // isLiked ? Icomoon.tulip_1 : Icomoon.tulip_outline,
                      Icomoon.tulip_outline,
                      color: isLiked ? Colors.red : Colors.grey 
                    ), 
                    // onPressed: () => _toggleCondolence(context, widget.funeral.id, isLiked),
                    onPressed: () => openModal(context),
                  ),
                  GestureDetector(
                    onTap: () => openModal(context),
                    child: Text("Condolences"))
                ]),
            ),
            Padding(
              padding: const EdgeInsets.only(right:30.0),
              child: Row(
                children: <Widget>[
                  // IconButton(
                  //   icon: Icon(
                  //     Icons.chat_bubble_outline,
                  //     color: Colors.grey
                  //     // isLiked ? Icons.favorite : Icons.favorite_border,
                  //     // color: isLiked ? Colors.red : Colors.grey 
                  //   ), 
                  //   onPressed: () => ComposePage.show(context: context, funeral: widget.funeral),
                  // ),
                  // GestureDetector(
                  //   onTap: () => {ComposePage.show(context: context, funeral: widget.funeral)},
                    
                  //   child: Text("Comment"))
                ]),
            ),
        
          ],),
        );
    
      }
    );
  }

  openModal(BuildContext context) {
     showModalBottomSheet(
          shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
                ),
          // isScrollControlled: false,
          isDismissible: true,
          backgroundColor: Colors.white,
          useRootNavigator: true,
          context: context,
          builder: (context) => Padding(
            padding: const EdgeInsets.only(top: 15.0, bottom: 25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                new ListTile(
                  leading: new Icon(Icomoon.tulip_outline, color: isLiked ? Colors.red : Colors.grey ),
                  title: condolenceMenuText(),
                  onTap: () => _toggleCondolence(context, widget.funeral.id, isLiked),          
                ),
                new ListTile(
                  leading: new Icon(Icons.chat_bubble_outline),
                  title: new Text('Condolences with comment'),
                  onTap: () => {
                    Navigator.pop(context),
                    ComposePage.show(context: context, funeral: widget.funeral),   
                  },
                ),
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.only(left: 15.0, right: 15.0),
                  child: RaisedButton(
                    onPressed: () => Navigator.pop(context),
                    elevation: 0.0,
                    highlightElevation: 0.0,
                    color: Colors.grey[100],
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                    ),
                    child: Text('Cancel',
                      style: TextStyle(fontSize: 15.0, fontWeight: FontWeight.normal)
                      ),
                  ),
                ),
               ]),
          ),
        );
  }

  Widget condolenceMenuText(){
    if(!isLiked){
      return Text('Condolences (Name only)');
    } else{
      return Text('Undo condolences', style: TextStyle(color: Colors.red));
    }
  }
}