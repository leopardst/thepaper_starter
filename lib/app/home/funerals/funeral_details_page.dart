import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:thepaper_starter/app/home/condolences/condolence_list_tile.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/routing/cupertino_tab_view_router.gr.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:thepaper_starter/app/home/condolences/condolence_list_tile.dart';
import 'package:thepaper_starter/app/home/condolences/condolence_button.dart';

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
                      child: _buildContent(context, _funeral),
                    ),
                  ],                 
                ),
                Text("33333"),
              ],
            ),
          ),
        ],
      ),
    );
    //   },
    // );
  }
  
   Widget _buildContent(BuildContext context, Funeral funeral) {
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

  // Future<void> _submitCondolence(BuildContext context, Funeral funeral) async {
  //   try {
  //     final database = Provider.of<FirestoreDatabase>(context, listen: false);
  //     final condolence = _condolenceFromState();
      
  //     await database.setCondolence(condolence, funeral.id);
  //   } on PlatformException catch (e) {
  //     PlatformExceptionAlertDialog(
  //       title: 'Operation failed',
  //       exception: e,
  //     ).show(context);
  //   }
  // }
}
