
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/funerals/funeral_details_page.dart';
import 'package:thepaper_starter/constants/text_themes.dart';
import 'package:timeago/timeago.dart' as timeago;

class FuneralListTile extends StatelessWidget {
  const FuneralListTile({
    Key? key,
    required this.funeral,
    required this.hero,
  }) : super(key: key);
  final Funeral funeral;
  final String hero;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FuneralDetailsPage.show(context, funeral),
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
        padding: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 0.3,
            ),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            _buildContent(),
            Container(
              padding: EdgeInsets.only(top: 25.0),
              child: Wrap(
                children: <Widget>[
                  Text("Posted ", style: TextThemes.helperText,),
                  Text(
                    timeago.format(funeral.createdDate!),
                    style: TextThemes.helperText,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _funeralTime(){
    if(funeral.funeralDate != null && funeral.funeralDate!.hour != 0){
      return Column(children: <Widget>[
        SizedBox(height: 5.0),
        Text(funeral.funeralTimeAsString, style: TextThemes.largeSubtitle),
      ],);
    }
    else{
      return Container();
    }
  }

  Widget _buildContent(){
    if(funeral.emptyImage){
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(child: _subContent()),
        ],
      );
    }
    else{
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Flexible(
            flex: 2,
            fit: FlexFit.tight,
            child: _subContent(),
          ),
          Flexible(
            flex: 1,
            child: _buildImage(),
          ),
        ],
      );
    }
  }

  Widget _subContent(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          child: Text(
            funeral.fullName,
            style: TextThemes.title,
            textScaleFactor: 1.0,
          ),
        ),
        SizedBox(height: 10.0),
        Text(funeral.formattedFuneralDate,  style: TextThemes.mediumSubtitle),
        // _funeralTime(),
        SizedBox(height: 5.0),
        // Text(funeral.location!),
        // SizedBox(height: 10.0),
      ],
    );
  }

  Widget _buildImage() {
    if(funeral.imageURL != null && funeral.imageURL != "https:"){
      return Hero(
        tag: "$hero${funeral.id}",
        transitionOnUserGestures: true,
        child: CachedNetworkImage(
          imageUrl: funeral.imageURL!,
          imageBuilder: (context, imageProvider) => Container(
            width: 100.0,
            height: 100.0,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10.0),
              image: DecorationImage(
                  image: imageProvider, fit: BoxFit.cover),
            ),
          ),
          placeholder: (context, url) => CircularProgressIndicator(),
          errorWidget: (context, url, error) => Icon(Icons.error),
        ),
      );
    } else{
      return Container();
    }
  }

 

  
}

