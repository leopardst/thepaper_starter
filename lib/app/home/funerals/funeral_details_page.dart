import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:flutter/services.dart';
import 'package:thepaper_starter/app/home/job_entries/entry_list_item.dart';
import 'package:thepaper_starter/app/home/job_entries/entry_page.dart';
import 'package:thepaper_starter/app/home/jobs/edit_job_page.dart';
import 'package:thepaper_starter/app/home/jobs/list_items_builder.dart';
// import 'package:thepaper_starter/app/home/models/entry.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/routing/cupertino_tab_view_router.gr.dart';
import 'package:thepaper_starter/services/firestore_database.dart';

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

  TabController _controller;

  @override
  void initState() {
    super.initState();
    _funeralFullName = widget.funeral?.fullName ?? '';
    _funeralImageURL = widget.funeral?.imageURL ?? '';
    _funeralLocation = widget.funeral?.location ?? '';
    _funeralObituary = widget.funeral?.obituary ?? '';
    _funeralFullDateAndTime = widget.funeral?.funeralFullDateAndTimeAsString ?? '';

    _controller = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
            Container(
              height: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(30.0),
                  boxShadow: [
                  BoxShadow(
                    color: Colors.black26,
                    offset: Offset(0.0, 2.0),
                    blurRadius: 6.0,
                  ),
                ],
              ),
              child:
                Hero(
                  tag: _funeralImageURL,
                  child: ClipRRect(
                    // borderRadius: BorderRadius.circular(30.0),
                      child: Image(
                      image: AssetImage(_funeralImageURL),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0),
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
            Positioned(
              left: 20.0,
              bottom: 20.0,
              child: Text(
                _funeralFullName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30.0,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 1.2,
                ),
              ),
            )
          ],
          ),
          Container(
            color: Colors.blue,
            child: TabBar(
              controller: _controller,
              tabs: [
                Tab(
                  icon: Icon(Icons.description),
                  text: 'Details',
                ),
                Tab(
                  icon: Icon(Icons.favorite),
                  text: 'Condolences',
                ),
                Tab(
                  icon: Icon(Icons.comment),
                  text: 'Comments',
                ),
              ],
            ),
          ),
          Expanded(
            // color: Colors.green,
            // height: 80.0,
            child: TabBarView(
              controller: _controller,
              children: <Widget>[
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Funeral Service: $_funeralFullDateAndTime'),
                    SizedBox(height: 10.0),
                    Text('Funeral Location: $_funeralLocation'),
                    SizedBox(height: 10.0),
                    Text('Obituary: $_funeralObituary'),
                    SizedBox(height: 10.0),
                  ],
                ),
                Text("222222"),
                Text("33333"),
              ],
            ),
          ),
        ],
      ),
    );
    //   },
    // );
  }

  // Widget _buildContent(BuildContext context, Funeral funeral) {
  //   final database = Provider.of<FirestoreDatabase>(context, listen: false);
  //   return StreamBuilder<List<Entry>>(
  //     stream: database.entriesStream(job: job),
  //     builder: (context, snapshot) {
  //       return ListItemsBuilder<Entry>(
  //         snapshot: snapshot,
  //         itemBuilder: (context, entry) {
  //           return DismissibleEntryListItem(
  //             key: Key('entry-${entry.id}'),
  //             entry: entry,
  //             job: job,
  //             onDismissed: () => _deleteEntry(context, entry),
  //             onTap: () => EntryPage.show(
  //               context: context,
  //               job: job,
  //               entry: entry,
  //             ),
  //           );
  //         },
  //       );
  //     },
  //   );
  // }
}
