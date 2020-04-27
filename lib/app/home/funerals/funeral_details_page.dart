import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'package:thepaper_starter/app/home/condolences/condolences_list_builder.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:thepaper_starter/routing/cupertino_tab_view_router.gr.dart';
import 'package:thepaper_starter/app/home/condolences/condolence_button.dart';
import 'package:thepaper_starter/constants/text_themes.dart';



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
                  _buildImage(),
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
      return Container(
        width: MediaQuery.of(context).size.width - 40.0,
        child: Hero(
          tag: _funeral.id,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: _funeralImageURL,
           ),
          ),
        ),
      );
    }
    else {
      return Container();
    }
  }

  Widget _buildCondolenceContent(BuildContext context, Funeral funeral){
   return CondolencesListBuilder(funeral: funeral);
  }
 

}
