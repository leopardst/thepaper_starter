import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/app/home/funerals/funeral_list_tile.dart';
import 'package:thepaper_starter/app/home/jobs/list_items_builder.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
// import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/constants/strings.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:google_fonts/google_fonts.dart';

class FuneralsPage extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(
          // title: Text(Strings.funerals),
          elevation: 0.0,
        ),
      ),
      body: _buildContents(context)
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return Padding(
      padding: const EdgeInsets.only(bottom: 100.0),
      child: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            floating: true,
            snap: true,
            flexibleSpace: FlexibleSpaceBar(
              centerTitle: false,
              titlePadding: EdgeInsetsDirectional.only(start: 20, bottom: 15),
              title: Text('the paper',
                style: GoogleFonts.notoSerif(
                  fontWeight: FontWeight.w600,  
                ),
              ),

            // collapseMode: CollapseMode.pin,
            // centerTitle: true,
              
            ) ,
          ),
        // padding: EdgeInsets.only(bottom: 100.0),
        StreamBuilder<List<Funeral>>(
          stream: database.funeralsStream(),
          builder: (context, snapshot) {
            return SliverList(
              delegate: SliverChildListDelegate([
              ListItemsBuilder<Funeral>(
                snapshot: snapshot,
                dontScroll: true,
                itemBuilder: (context, funeral) => FuneralListTile(
                  funeral: funeral,
                ),
              ),
            ]));
                
                
            //     (BuildContext context, int index) {
            //     return FuneralListTile(funeral: snapshot.data[index]);
            //   },
            //   childCount: snapshot.hasData ? snapshot.data.length : 0,
            // 
          },
        ),
        ]),
    );
  }
}
