import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/app/home/funerals/funeral_details_page.dart';

import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/condolences/compose_page.dart';
import 'package:thepaper_starter/app/home/models/user_profile.dart';
import 'package:thepaper_starter/common_widgets/platform_alert_dialog.dart';
import 'package:thepaper_starter/common_widgets/avatar.dart';
import 'package:thepaper_starter/constants/text_themes.dart';

import 'package:thepaper_starter/services/firebase_auth_service.dart';
import 'package:thepaper_starter/services/firestore_database.dart';

class AccountCondolenceListTile extends StatefulWidget {
  const AccountCondolenceListTile({Key key, @required this.condolence}) : super(key: key);

  final UserCondolence condolence;

  @override
  _AccountCondolenceListTileState createState() => _AccountCondolenceListTileState();
}

class _AccountCondolenceListTileState extends State<AccountCondolenceListTile> {

  Future<void> _showFuneral(String funeralId) async {    
    
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    final funeral = await database.funeralStream(funeralId: funeralId).first;
    FuneralDetailsPage.show(context, funeral);

  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTile(
        onTap: () => _showFuneral(widget.condolence.id),      
        trailing: buildImage(widget.condolence.imageURL),
        title: Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
            Text(widget.condolence.name, style: TextThemes.smallTitle),
            Text(new DateFormat('EEEE, MMMM dd, yyyy').format(widget.condolence.funeralDate), style: TextThemes.smallSubtitle),
            // daysToAnniversary(condolence.funeralDate),
          ]),
        ),
      ),
      ]);
  }

  Widget buildImage(String imageURL){
    if(imageURL == null){
      return Container(width: 44.0,);
    }else{
      return ClipRRect(
              borderRadius: BorderRadius.circular(10.0),
              child: CachedNetworkImage(
                imageUrl: imageURL,
         ));
    }
  }

  Widget daysToAnniversary(DateTime funeralDate){
    var today = new DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day);

    var funeralNextYear = new DateTime(
      funeralDate.year + 1,
      funeralDate.month,
      funeralDate.day 
    );

    Duration difference =  funeralNextYear.difference(today);

    return Text('${difference.inDays} months until next anniversary');
  }
}