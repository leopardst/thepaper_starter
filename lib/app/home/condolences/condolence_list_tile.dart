import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/condolences/compose_page.dart';
import 'package:thepaper_starter/common_widgets/platform_alert_dialog.dart';

class CondolenceListTile extends StatelessWidget {
  const CondolenceListTile({Key key, @required this.condolence, @required this.funeral}) : super(key: key);
  final Condolence condolence;
  final Funeral funeral;



  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 0.0),
      child: ListTile(
        leading: Container(
          width: 50.0,
          height: 50.0,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
          ),
          child: CircleAvatar(
            child: ClipOval(
              child: Image(
                height: 50.0,
                width: 50.0,
                image: AssetImage('assets/images/GreenMorty.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
        ),
        title: Text(
          condolence.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        subtitle: GestureDetector(
          onTap: () => ComposePage.show(context: context, condolence: condolence, funeral: funeral),
          child: Text(condolence?.message ?? "Add a message...")
        ),
        // trailing: IconButton(
        //   icon: Icon(
        //     Icons.favorite_border,
        //   ),
        //   color: Colors.grey,
        //   onPressed: () => print('Like comment'),
        // ),
      ),
    );
  }

  
}
