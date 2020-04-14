
import 'package:flutter/material.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/funerals/funeral_details_page.dart';



class FuneralListTile extends StatelessWidget {
  const FuneralListTile({Key key, @required this.funeral}) : super(key: key);
  final Funeral funeral;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => FuneralDetailsPage.show(context, funeral),      child: Container(
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
            Hero( //TODO Fix the hero animation
              tag: funeral.imageURL,
              child: Image(
                height: 100.0,
                width: 100.0,
                image: AssetImage(funeral.imageURL),
                fit: BoxFit.cover,
              ),
            ),
          ],
        ),
      ),
    );


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

