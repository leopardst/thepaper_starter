import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/app/home/comments/comment_field.dart';

import 'package:thepaper_starter/app/home/comments/condolences_feed_list_builder.dart';
import 'package:thepaper_starter/app/home/groups/group_page.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/common_widgets/avatar.dart';
import 'package:thepaper_starter/routing/cupertino_tab_view_router.dart';

import 'package:thepaper_starter/app/home/condolences/condolence_button.dart';
import 'package:thepaper_starter/app/home/condolences/condolence_count.dart';
import 'package:thepaper_starter/constants/text_themes.dart';
import 'package:thepaper_starter/common_widgets/expandable_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:thepaper_starter/routing/router.dart';
import 'package:thepaper_starter/services/analytics_service.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';
import 'package:thepaper_starter/services/firestore_database.dart';

class FuneralDetailsPage extends StatefulWidget {
  const FuneralDetailsPage({required this.funeral, required this.parent});
  final Funeral? funeral;
  final String? parent;

  static Future<void> show(BuildContext context, Funeral funeral) async {
    final analyticsService =
        Provider.of<AnalyticsService>(context, listen: false);
    analyticsService.logViewedFuneralPage(funeral.fullName, funeral.id);

    await Navigator.of(context, rootNavigator: true).pushNamed(
      Routes.funeralDetailsPage,
      arguments: {
        'funeral': funeral,
        'parent': context.widget.toString(),
      },
    );
  }

  @override
  State<StatefulWidget> createState() => _FuneralDetailsPageState();
}

class _FuneralDetailsPageState extends State<FuneralDetailsPage>
    with SingleTickerProviderStateMixin {
  late String _funeralFullName;
  String? _funeralImageURL;
  String? _funeralLocation;

  String? _funeralObituary;
  Funeral? _funeral;
  // String? _name;
  String? _userImageURL;

  // TabController _controller;
  final TextEditingController textEditingController =
      new TextEditingController();

  final scrollKey = new GlobalKey();

  @override
  void initState() {
    super.initState();
    _funeralFullName = widget.funeral?.fullName ?? '';
    _funeralImageURL = widget.funeral!.imageURL ?? '';
    _funeralLocation = widget.funeral?.location ?? '';
    _funeralObituary = widget.funeral?.obituaryClean ?? '';
    _funeral = widget.funeral; // TODO this cant be right

   final user = Provider.of<AppUser>(context, listen:false);
    // _name = user.displayName ?? user.email;
    _userImageURL = user.photoURL ?? null;
    // _controller = new TabController(length: 3, vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return StreamProvider<Condolence?>.value(
      value: database.condolenceStream(funeralId: _funeral!.id),
      initialData: null,
      catchError: (_, __) => null,
      child: Scaffold(
        body: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.fromLTRB(10.0, 30.0, 10.0, 10.0),
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
            Expanded(
              child: SingleChildScrollView(
                physics: ScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  children: <Widget>[
                    _buildImage(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 20.0),
                      child: Container(
                        width: double.infinity,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              _funeralFullName,
                              style: TextThemes.title,
                              textScaleFactor: 1.0,
                            ),
                            // Text("Funeral Service", style: TextThemes.subtitle),
                            SizedBox(
                              height: 15.0,
                            ),
                            Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: <Widget>[
                                  Padding(
                                    padding: EdgeInsets.only(right: 10.0),
                                    child:
                                        Icon(Icons.today, color: TextThemes.accentColor),
                                  ),
                                  Text(widget.funeral!.formattedFuneralDate),
                                ]),
                            SizedBox(
                              height: 10.0,
                            ),
                            funeralLocation(),
                            _buildGroups(),
                            SizedBox(
                              height: 25.0,
                            ),
                            obitSection(),
                            SizedBox(
                              key: scrollKey,
                              height: 15,
                            ),
                            // CondolenceButton(funeral: _funeral),
                            Container(
                              height: 20,
                              decoration: BoxDecoration(
                                border: Border(
                                    top: BorderSide(
                                      color: Colors.grey,
                                      width: 0.3,
                                    ),
                                ),
                              ),
                            ),
                            CondolenceCount(funeral: _funeral),
                            _buildCommentList(context, _funeral),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 25.0,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      bottomNavigationBar: StickyBottomAppBar(
        child: BottomAppBar(
          child: Container(
            padding: const EdgeInsets.fromLTRB(10.0, 10.0, 10.0, 0.0),
            height: 70,
            // width: double.maxFinite,
            child:  Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Avatar(photoUrl: _userImageURL, radius: 20.0),
                CommentField(funeral: _funeral, scrollKey: scrollKey),
                CondolenceButton(funeral: _funeral),
              ],    
            ),
          ),
        ),
      ),
      ),
    );
  }

  Widget funeralLocation() {
    if (_funeralLocation != null && _funeralLocation != "") {
      return Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Icon(Icons.location_on, color: TextThemes.accentColor),
            ),
            Flexible(child: Text(_funeralLocation!)),
          ]);
    } else {
      return Container();
    }
  }

  Widget obitSection() {
    if (_funeralObituary != '') {
      return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Obituary", style: TextThemes.largeSubtitle),
            SizedBox(
              height: 10.0,
            ),
            ExpandableText(_funeralObituary),
          ]);
    } else {
      return Container();
    }
  }

  Widget _buildGroups() {
    //TODO could extract into a widget
    if (_funeral!.groups!.length > 0) {
      return Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Row(children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 10.0),
            child: Icon(Icons.group, color: Colors.grey),
          ),
          Row(
              children: _funeral!.groups!
                  .map((item) => GestureDetector(
                        child: new Chip(
                          label: Text(item.name!),
                        ),
                        onTap: () => GroupPage.show(context, groupId: item.id),
                      ))
                  .toList())
        ]),
      );
    } else {
      return Container();
    }
  }

  Widget _buildImage() {
    //TODO refactor this since it exists twice
    if (_funeralImageURL != null && _funeralImageURL != '') {
      return Container(
        // width: MediaQuery.of(context).size.width - 40.0,
        constraints:
            BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 40.0),
        child: Hero(
          tag: "${_funeral!.id}",
          transitionOnUserGestures: true,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: _funeralImageURL!,
            ),
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget _buildCommentList(BuildContext context, Funeral? funeral) {
    return CondolencesFeedListBuilder(funeral: funeral);
  }
}

class StickyBottomAppBar extends StatelessWidget {
  final BottomAppBar child;
  StickyBottomAppBar({required this.child});

  @override
  Widget build(BuildContext context) {
    return Transform.translate(
      offset: Offset(0.0, -1 * MediaQuery.of(context).viewInsets.bottom),
      child: child,
    );
  }
}
