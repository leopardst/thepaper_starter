
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/funerals/funeral_details_page.dart';
import 'package:timeago/timeago.dart' as timeago;

class FuneralListTile extends StatelessWidget {
  const FuneralListTile({Key key, @required this.funeral}) : super(key: key);
  final Funeral funeral;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FuneralDetailsPage.show(context, funeral),      
        child: Container(
        // height: 10,
        // constraints: BoxConstraints(minHeight: 140.0),
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
        padding: EdgeInsets.only(bottom: 10.0),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: Colors.grey,
              width: 0.3,
              )
          ),
          // color: Colors.blue,
          // borderRadius: BorderRadius.circular(20.0),
        ),
        child: 
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              _buildContent(),
              Container(
                padding: EdgeInsets.only(top: 25.0),
                child: Wrap(
                  children: <Widget>[
                    // Text("Paperman & Sons · ",
                    //   style: TextStyle(color: Colors.grey[600])
                    // ),
                    Text(
                      timeago.format(funeral.createdDate),
                      style: TextStyle(color: Colors.grey[600])
                    ),
                    
                  ]),
              ),
            ]),
      ),
    );
  }

  Widget _funeralTime(){
    if(funeral.funeralDate.hour != 0){
      return Column(children: <Widget>[
        SizedBox(height: 5.0),
        Text(funeral.funeralTimeAsString),
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
              // fit: FlexFit.tight,
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
          // width: 200.0,
          child: Text(
            funeral.fullName,
            style: TextStyle(
              fontSize: 22.0,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.2,
            ),
          ),
        ),
        SizedBox(height: 5.0),
        Text(funeral.funeralDateAsString),
        _funeralTime(),
        SizedBox(height: 5.0),
        Text(funeral.location),
        SizedBox(height: 10.0),
      ],
    );

  }

  Widget _buildImage() {
    if(funeral.imageURL != null && funeral.imageURL != "https:"){
      // return Image.network(funeral.imageURL);
      return Hero(
        tag: funeral.id,
        transitionOnUserGestures: true,
        child: CachedNetworkImage(
          imageUrl: funeral.imageURL,
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
    } else{return Container();}
    // else{
    //   return ClipRRect(
    //     borderRadius: BorderRadius.circular(10.0),
    //     child: Image(
    //     height: 100.0,
    //     width: 100.0,
    //     image: AssetImage('assets/images/GreenMorty.jpg'),
    //     fit: BoxFit.cover,
    //   ));
    // }
  }

 

  
}

