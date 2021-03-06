import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_search_bar/search_bar_style.dart';
import 'package:thepaper_search_bar/thepaper_search_bar.dart';
import 'package:thepaper_starter/app/home/search/search_list_tile.dart';
import 'package:thepaper_starter/services/analytics_service.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{
  
  final SearchBarController<AlgoliaObjectSnapshot> _searchBarController = SearchBarController();
  static final _borderSide = BorderSide(
    color: Colors.grey[400]!,
    width: 1.0
  );

  Algolia algolia = Algolia.init(
    applicationId: 'H51U8BPLQV',
    apiKey: 'e011058d5e69a218b2cc7012e68248c4',
  );

  Future<List<AlgoliaObjectSnapshot>> search2(String? input) async {    
    List<AlgoliaObjectSnapshot> results = new List<AlgoliaObjectSnapshot>.empty(growable: true);
    // AlgoliaSettings settingsData = algolia.instance.index('funerals').settings;
    // settingsData = settingsData.setSnippetEllipsisText('[&hellip;]');
    // AlgoliaTask setSettings = await settingsData.setSettings();
    
    AlgoliaQuery query = algolia.instance.index("funerals").search(input!);
    query = query.setFacetFilter('isLive:true');
    query = query.setFacetFilter('isDeleted:false');

    AlgoliaQuerySnapshot snap = await query.getObjects();
    results = snap.hits;

    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
    analyticsService.logSearched(input, results.length);

    return results;
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<AlgoliaObjectSnapshot?>(
            searchBarController: _searchBarController ,
            searchBarStyle: SearchBarStyle(
              borderRadius: BorderRadius.circular(18),
              backgroundColor: Colors.white,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              border: Border(top: _borderSide, bottom: _borderSide, left: _borderSide, right: _borderSide)
            ),
            // placeHolder: ('hello'),
            onSearch: search2,
            hintText: "Search",
            hintStyle: TextStyle(
              color: Colors.grey[600],
              fontSize: 18.0,
            ),
            iconActiveColor: Colors.black,
            icon: Icon(
              Icons.search,
              color: Colors.grey[400],
            ),
            emptyWidget: Padding(
              padding: const EdgeInsets.only(top: 10.0, left: 5.0),
              child: Text("No results found"),
            ),
            onItemFound: (AlgoliaObjectSnapshot? snap, int index){
              return SearchListTile(snap: snap, index: index);
            },
          ),
        ),
      ),
    );
  }

}