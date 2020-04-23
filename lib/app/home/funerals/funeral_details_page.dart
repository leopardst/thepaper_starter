import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:thepaper_starter/app/home/condolences/condolences_list_builder.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/app/home/models/comment.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/routing/cupertino_tab_view_router.gr.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:thepaper_starter/app/home/condolences/condolence_list_tile.dart';
import 'package:thepaper_starter/app/home/condolences/condolence_button.dart';
import 'package:thepaper_starter/app/home/comments/comments_list_tile.dart';
import 'package:thepaper_starter/constants/text_themes.dart';

import 'package:thepaper_starter/app/home/jobs/list_items_builder.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';
import 'package:animated_stream_list/animated_stream_list.dart';


class FuneralDetailsPage extends StatefulWidget {
  const FuneralDetailsPage({@required this.funeral});
  final Funeral funeral;

  static Future<void> show(BuildContext context, Funeral funeral) async {
    await Navigator.of(context).pushNamed(
      CupertinoTabViewRouter.funeralDetailsPage,
      arguments: funeral,
    );
  }

  @override
  State<StatefulWidget> createState() => _FuneralDetailsPageState();
}

class _FuneralDetailsPageState extends State<FuneralDetailsPage> with SingleTickerProviderStateMixin {
  String _funeralFullName;
  String _funeralImageURL;
  String _funeralLocation;
  String _funeralFullDateAndTime;
  String _funeralObituary;
  Funeral _funeral;
  TabController _controller;
  final TextEditingController textEditingController = new TextEditingController();


  @override
  void initState() {
    super.initState();
    _funeralFullName = widget.funeral?.fullName ?? '';
    _funeralImageURL = widget.funeral.imageURL ?? '';
    _funeralLocation = widget.funeral?.location ?? '';
    _funeralObituary = widget.funeral?.obituary ?? '';
    _funeralFullDateAndTime = widget.funeral?.funeralFullDateAndTimeAsString ?? '';
    _funeral = widget.funeral; // TODO this cant be right

    _controller = new TabController(length: 3, vsync: this);
  }


Comment _commentFromState(String _content) {
    final user = Provider.of<User>(context, listen:false);
    final name = user.email;
    final uid = user.uid;
    final id = documentIdFromCurrentDate();
    final content = _content;

    return Comment(
      id: id,
      uid: uid,
      name: name,
      content: content,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                IconButton(
                  icon: Icon(Icons.arrow_back),
                  iconSize: 30.0,
                  color: Colors.black,
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
          ),
          Expanded(
            child: SingleChildScrollView(
              physics: ScrollPhysics(),
              child: Column(
                children: <Widget>[
                  Container(
                  height: MediaQuery.of(context).size.width - 40.0,
                  child: Hero(
                    tag: _funeral.id,
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10.0),
                        child: _buildImage(),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 20.0),
                  child: Container(
                    width: double.infinity,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                      Text(_funeralFullName,
                        style: TextStyle(
                          fontSize: 20.0,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 1.2,
                        ),
                      ),
                      SizedBox(height: 20.0,),
                      Text("Funeral Service", style: TextThemes.subtitle),
                      SizedBox(height: 10.0,),
                      Text(_funeralFullDateAndTime),
                      SizedBox(height: 10.0,),
                      Text(_funeralLocation),
                      SizedBox(height: 20.0,),
                      Text("Obituary", style: TextThemes.subtitle),
                      SizedBox(height: 10.0,),
                      Text(_funeralObituary),
                      SizedBox(height: 10.0,),
                      CondolenceButton(funeral: _funeral),
                      _buildCondolenceContent(context, _funeral),
                    ],),
                  ),
                ),
                
                // Expanded(
                //    child:
                // ),
                SizedBox(height: 100.0,),

              ],),
            ),
          )
        ],
      ),
    );
  }



  Widget _buildImage() { //TODO refactor this since it exists twice
    if(_funeralImageURL != null && _funeralImageURL != ''){
      
      return CachedNetworkImage(
        imageUrl: _funeralImageURL,
      );
    }
    else {
      return Image(
        image: AssetImage('assets/images/GreenMorty.jpg'),
        fit: BoxFit.cover,
      );
    }
  }

  Widget _buildCondolenceContent(BuildContext context, Funeral funeral){
   return CondolencesListBuilder(funeral: funeral);
  }
  // Widget _buildCondolenceContent(BuildContext context, Funeral funeral) {
  //   final database = Provider.of<FirestoreDatabase>(context, listen: false);
  //   return AnimatedStreamList<Condolence>(
  //     streamList: database.condolencesStream(funeral: funeral),
  //     scrollPhysics: NeverScrollableScrollPhysics(),
  //     shrinkWrap: true, 
  //     itemBuilder: (item, index, context, animation) =>      
  //       _createCondolenceTile(item, animation),      
  //     itemRemovedBuilder: (item, index, context, animation) =>  
  //       _createRemovedCondolenceTile(item, animation), 
  //   ); 
  // }

    // create tile view as the user is going to see it, attach any onClick callbacks etc. 
 

  Widget buildInput() {
    return Container(
      child: Row(
        children: <Widget>[
          // Edit text
          Flexible(
            child: Container(
              child: TextField(
                style: TextStyle(color: Colors.black, fontSize: 15.0),
                controller: textEditingController,
                decoration: InputDecoration.collapsed(
                  hintText: 'Send a message...',
                  hintStyle: TextStyle(color: Colors.grey),
                ),
                // focusNode: focusNode,
              ),
            ),
          ),

          // Button send message
          Material(
            child: new Container(
              margin: new EdgeInsets.symmetric(horizontal: 8.0),
              child: new IconButton(
                icon: new Icon(Icons.send),
                onPressed: () => _sendMessage(context,widget.funeral.id, textEditingController.text),
                color: Colors.black,
              ),
            ),
            color: Colors.white,
          ),
        ],
      ),
      width: double.infinity,
      height: 50.0,
      decoration: new BoxDecoration(
          border: new Border(top: new BorderSide(color: Colors.grey, width: 0.5)), color: Colors.white),
    );
  }


  Future<void> _sendMessage(BuildContext context, String funeralId, String content) async {
    if (content.trim() != '') {
      textEditingController.clear();
      try {
        final database = Provider.of<FirestoreDatabase>(context, listen: false);
        final comment = _commentFromState(content);
        await database.setComment(comment, funeralId);
        // listScrollController.animateTo(0.0, duration: Duration(milliseconds: 300), curve: Curves.easeOut);

      } on PlatformException catch (e) {
        PlatformExceptionAlertDialog(
          title: 'Operation failed',
          exception: e,
        ).show(context);
      }
    }
  }

  Widget _buldCommentsList(BuildContext context, Funeral funeral) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder<List<Comment>>(
      stream: database.commentsStream(funeral: funeral),
      builder: (context, snapshot) {
        return ListItemsBuilder<Comment>(
          snapshot: snapshot,
          itemBuilder: (context, comment) => CommentsListTile(
            comment: comment,
          ),
        );
      },
    );
  }
}
