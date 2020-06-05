import 'dart:async';

import 'package:flappy_search_bar/flappy_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:algolia/algolia.dart';
import 'package:thepaper_starter/app/home/search/search_list_tile.dart';


class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>{
  TextEditingController _searchText = TextEditingController(text: "");
  List<AlgoliaObjectSnapshot> _results = [];
  bool _searching = false;

  Algolia algolia = Algolia.init(
    applicationId: 'H51U8BPLQV',
    apiKey: 'e011058d5e69a218b2cc7012e68248c4',
  );

  // AlgoliaSettings settingsData = settingsRef;
  // settingsData = settingsData.setReplicas(const ['index_copy_1', 'index_copy_2']);
  // AlgoliaTask setSettings = await settingsData.setSettings();



  _search() async {
    setState(() {
      _searching = true;
    });


    AlgoliaQuery query = algolia.instance.index('funerals');
    query = query.search(_searchText.text);

    _results = (await query.getObjects()).hits;
    
    setState(() {
      _searching = false;
    });
  }

  Future<List<AlgoliaObjectSnapshot>> search2(String input) async {    
    List<AlgoliaObjectSnapshot> results = new List<AlgoliaObjectSnapshot>();
    // AlgoliaSettings settingsData = algolia.instance.index('funerals').settings;
    // settingsData = settingsData.setSnippetEllipsisText('[&hellip;]');
    // AlgoliaTask setSettings = await settingsData.setSettings();
    
    AlgoliaQuery query = algolia.instance.index("funerals").search(input);
    query = query.setFacetFilter('isLive:true');
    query = query.setFacetFilter('isDeleted:false');

    AlgoliaQuerySnapshot snap = await query.getObjects();
    results = snap.hits;
    return results;
  }

  _searchOperation(String input) {
    if (input.length > 0) {
      Duration duration = Duration(milliseconds: 700);
      Timer(duration, () {
        if (input == _searchText.text) {
          // input hasn't changed in the last 500 milliseconds..
          // you can start search
          print('Now !!! search term : ' + _searchText.text);
          _search();
        } else {
          //wait.. Because user still writing..
          print('Not Now');
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SearchBar<AlgoliaObjectSnapshot>(
            onSearch: search2,
            hintText: "Search",
            hintStyle: TextStyle(
              color: Colors.grey[600],
            ),
            emptyWidget: Padding(
              padding: const EdgeInsets.only(top: 4.0),
              child: Text("No results found"),
            ),
            onItemFound: (AlgoliaObjectSnapshot snap, int index){
              return SearchListTile(snap: snap, index: index);
            },
          ),
        ),
      ),
    );
  }
  
  // @override
  // Widget build(BuildContext context) {
  //   return Scaffold(
  //     body: Container(
  //       padding: EdgeInsets.only(top: 30.0),
  //       margin: EdgeInsets.fromLTRB(20.0, 20.0, 20.0, 5.0),
  //       child: Column(
  //         crossAxisAlignment: CrossAxisAlignment.start,
  //         children: <Widget>[
  //           TextField(
  //             controller: _searchText,
  //             decoration: InputDecoration(hintText: "Search"),
  //             onChanged: (val){
  //               if(val.length > 2){
  //                 _searchOperation(val);
  //               }
  //             },
  //           ),
  //           Expanded(
  //             child: _searching == true
  //                 ? Center(
  //                     child: Text("Searching, please wait..."),
  //                   )
  //                 : _results.length == 0
  //                     ? Center(
  //                         child: Text("No results found."),
  //                       )
  //                     : ListView.builder(
  //                         itemCount: _results.length,
  //                         itemBuilder: (BuildContext ctx, int index) {
  //                           AlgoliaObjectSnapshot snap = _results[index];
                    
  //                           print(snap.highlightResult["obituary"]);
  //                           return ListTile(
  //                             leading: CircleAvatar(
  //                               child: Text(
  //                                 (index + 1).toString(),
  //                               ),
  //                             ),
  //                             title: Text(snap.data["firstName"]),
  //                             subtitle: Text(snap.snippetResult["obituary"]["value"]),
  //                           );
  //                         },
  //                       ),
  //           ),
  //         ],
  //       ),
  //     ), // This trailing comma makes auto-formatting nicer for build methods.
  //   );
  // }


}