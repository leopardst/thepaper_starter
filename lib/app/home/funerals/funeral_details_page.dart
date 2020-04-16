import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/app/home/models/comment.dart';

import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/routing/cupertino_tab_view_router.gr.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:thepaper_starter/app/home/condolences/condolence_list_tile.dart';
import 'package:thepaper_starter/app/home/condolences/condolence_button.dart';
import 'package:thepaper_starter/app/home/comments/comments_list_tile.dart';

import 'package:thepaper_starter/app/home/jobs/list_items_builder.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';


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
    _funeralImageURL = widget.funeral?.imageURL ?? '';
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
          Stack(
            children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child:
                Hero(
                  tag: _funeralImageURL,
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(30.0),
                      child: Image(
                      image: AssetImage(_funeralImageURL),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
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
            Positioned(
              left: 20.0,
              bottom: 20.0,
              child: Text(
                _funeralFullName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            )
          ],
          ),
          Container(
            color: Colors.blue,
            child: TabBar(
              controller: _controller,
              tabs: [
                Tab(
                  icon: Icon(Icons.description),
                  text: 'Details',
                ),
                Tab(
                  icon: Icon(Icons.favorite),
                  text: 'Condolences',
                ),
                Tab(
                  icon: Icon(Icons.comment),
                  text: 'Comments',
                ),
              ],
            ),
          ),
          Expanded(
            // color: Colors.green,
            // height: 80.0,
            child: TabBarView(
              controller: _controller,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Funeral Service: $_funeralFullDateAndTime'),
                    SizedBox(height: 10.0),
                    Text('Funeral Location: $_funeralLocation'),
                    SizedBox(height: 10.0),
                    Text('Obituary: $_funeralObituary'),
                    SizedBox(height: 10.0),
                  ],
                ),
                Column(
                  children: <Widget>[
                    CondolenceButton(funeral: _funeral),
                    Expanded(
                      // height: 100.0,
                      child: _buildCondolenceContent(context, _funeral),
                    ),
                  ],                 
                ),
                Column(
                  children: <Widget>[
                    // _buildCommentInput(funeral: _funeral),
                    Container(
                      height: 200.0,
                      child: _buldCommentsList(context, _funeral),
                    ),
                    buildInput(),
                  ],                 
                ),
              ],
            ),
          ),
        ],
      ),
    );
    //   },
    // );
  }

  
   Widget _buildCondolenceContent(BuildContext context, Funeral funeral) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamBuilder<List<Condolence>>(
      stream: database.condolencesStream(funeral: funeral),
      builder: (context, snapshot) {
        return ListItemsBuilder<Condolence>(
          snapshot: snapshot,
          itemBuilder: (context, condolence) => CondolenceListTile(
            condolence: condolence,
          ),
        );
      },
    );
  }

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
                  hintText: 'Type your message...',
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
