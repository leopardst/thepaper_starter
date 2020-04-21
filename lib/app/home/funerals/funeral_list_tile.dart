
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/funerals/funeral_details_page.dart';

class FuneralListTile extends StatelessWidget {
  const FuneralListTile({Key key, @required this.funeral}) : super(key: key);
  final Funeral funeral;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FuneralDetailsPage.show(context, funeral),      
        child: Container(
        height: 140.0,
        width: double.infinity,
        margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 200.0,
                  child: Text(
                    funeral.fullName,
                    style: TextStyle(
                      fontSize: 22.0,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
                SizedBox(height: 5.0,),
                Text(funeral.funeralFullDateAndTimeAsString),
                SizedBox(height: 5.0,),
                Text(funeral.location),
              ],
            ),
            Hero(
              tag: funeral.id,
              child: _buildImage()
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage() {
    if(funeral.imageURL != null && funeral.imageURL != "https:"){
      // return Image.network(funeral.imageURL);
      return CachedNetworkImage(
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

  List<TextSpan> _processCaption(
      String caption, String matcher, TextStyle style) {
    List<TextSpan> spans = [];

    caption.split(' ').forEach((text) {
      if (text.toString().contains(matcher)) {
        spans.add(TextSpan(text: text + ' ', style: style));
      } else {
        spans.add(TextSpan(text: text + ' '));
      }
    });

    return spans;
  }

  
}

