import 'package:algolia/algolia.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_html/style.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/app/home/funerals/funeral_details_page.dart';
import 'package:thepaper_starter/constants/text_themes.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:flutter_html/flutter_html.dart';

class SearchListTile extends StatefulWidget {
  const SearchListTile({Key? key, required this.snap, required this.index}) : super(key: key);
  
  final AlgoliaObjectSnapshot? snap;
  final int index;

  @override
  _SearchListTileState createState() => _SearchListTileState();
}

class _SearchListTileState extends State<SearchListTile> {

  Future<void> _showFuneral(String funeralId) async {    
    
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    final funeral = await database.funeralStream(funeralId: funeralId).first;
    FuneralDetailsPage.show(context, funeral);

  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => _showFuneral(widget.snap!.objectID),      
        child: Container(
        width: double.infinity,
        padding: EdgeInsets.only(top: 10.0, bottom: 10.0),
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
            ]),
      ),
    );
  }


  Widget _buildContent(){
  
    if(widget.snap!.snippetResult!["obituary"]["matchLevel"] == "full"){
      return ListTile(
        trailing: _buildImage(),
        title: Wrap(
          direction: Axis.horizontal,
          spacing: 4,
          children: <Widget>[
            Text(widget.snap!.data["firstName"], style: TextThemes.title2),
            Text(widget.snap!.data["lastName"], style: TextThemes.title2),
          ]
        ),        
        subtitle: MediaQuery(
          data: MediaQueryData(textScaleFactor: 1.0),
          child: Html(
          data: widget.snap!.snippetResult!["obituary"]["value"],
          style: 
            {
              '*': Style(
                fontSize: FontSize(15.0),

              ),
            },       
          ),
        )
    );  
    }
    else{
      return ListTile(
        trailing: _buildImage(),
        title: Wrap(
          direction: Axis.horizontal,
          spacing: 4,
          children: <Widget>[
            Text(widget.snap!.data["firstName"], style: TextThemes.title2),
            Text(widget.snap!.data["lastName"], style: TextThemes.title2),
          ]
        ),
        // subtitle: Text(widget.snap.snippetResult["obituary"]["value"]),
      );  
    }
   
  }

  Widget? _buildImage() {
    if(widget.snap!.data["imageURL"] != null && widget.snap!.data["imageURL"] != "https:"){
      // return Image.network(funeral.imageURL);

      return Hero(
        tag: "${widget.snap!.objectID}",
        transitionOnUserGestures: true,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: 44,
            minHeight: 44,
            maxWidth: 64,
            maxHeight: 64,
          ),
          child: CachedNetworkImage(
            imageUrl: widget.snap!.data["imageURL"],
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
        ),
      );
    } 
    else{
      return null;
    }
  }

 

  
}

