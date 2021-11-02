import 'dart:async';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/app/home/search/search_list_tile.dart';
import 'package:thepaper_starter/services/analytics_service.dart';
import 'package:flappy_search_bar_fork/flappy_search_bar.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{

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
            onSearch: search2,
            hintText: "Search",
            hintStyle: TextStyle(
              color: Colors.grey[600],
            ),
            emptyWidget: Padding(
              padding: const EdgeInsets.only(top: 4.0),
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