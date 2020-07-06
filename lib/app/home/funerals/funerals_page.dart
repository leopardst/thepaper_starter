import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/app/home/calendar/calendar_page.dart';
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
        body: _buildContents(context));
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return CustomScrollView(slivers: <Widget>[
      SliverAppBar(
        floating: true,
        snap: true,
        flexibleSpace: FlexibleSpaceBar(
          centerTitle: false,
          titlePadding: EdgeInsetsDirectional.only(start: 20, bottom: 15),
          title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'the paper',
                  style: GoogleFonts.notoSerif(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  // onPressed: () => CalendarPage.show(context: context)
                  onPressed: () => showModalBottomSheet(
                    useRootNavigator: true,
                    context: context,
                    backgroundColor: Colors.transparent,
                    builder: (context) => CalendarPage(),
                  ),
                ),
              ]),
        ),
      ),
      StreamBuilder<List<Funeral>>(
        stream: database.funeralsStreamSinceDaysAgo(
          daysAgo: 30,
        ),
        // stream: database.funeralsStream(),
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
        },
      ),
    ]);
  }
}
