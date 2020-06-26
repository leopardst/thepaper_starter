import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:thepaper_starter/app/home/comments/condolence_feed_list_tile.dart';
// import 'dart:async';


import 'package:thepaper_starter/app/home/jobs/empty_content.dart';
import 'package:thepaper_starter/app/home/models/comment.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';

import 'package:animated_stream_list/animated_stream_list.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:thepaper_starter/app/home/condolences/emptiable_list.dart';

// typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item, Animation animation);

class CondolencesFeedListBuilder extends StatelessWidget {
  const CondolencesFeedListBuilder({
    Key key,
    // @required this.snapshot,
    // @required this.itemBuilder,
    @required this.funeral,
  }) : super(key: key);
  // final AsyncSnapshot<List<T>> snapshot;
  // final ItemWidgetBuilder<T> itemBuilder;
  final Funeral funeral;
  

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return FutureBuilder<List>(
      future: database.condolencesList(funeral: funeral),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        debugPrint('comment snapshot: $snapshot'); //TODO Remove this
        if (snapshot.hasData) {
          final List<Condolence> items = snapshot.data;
          return _buildList(context, items);
      } else if (snapshot.hasError) {
        return EmptyContent(
          title: 'Something went wrong',
          message: 'Can\'t load items right now',
        );
      }
      return Center(child: CircularProgressIndicator());

    });
  }

//EmptyContent()

  Widget _buildList(BuildContext context, List<Condolence> initialItems) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    final stream = database.condolencesStream(funeral: funeral);
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: EmptiableList(
          listStream: stream,
          // placeholder: EmptyContent(),
          list: AnimatedStreamList<Condolence>(
            streamList: stream,
            // initialList: initialItems,
            scrollPhysics: NeverScrollableScrollPhysics(),
            shrinkWrap: true, 
            itemBuilder: (item, index, context, animation) =>      
              _createCondolenceFeedTile(item, animation),      
            itemRemovedBuilder: (item, index, context, animation) =>  
              _createRemovedCondolenceFeedTile(item, animation), 
        ),
      ),
    );
  }

  Widget _createCondolenceFeedTile(Condolence condolence, Animation<double> animation) {    
    return FadeTransition(      
      // axis: Axis.vertical,      
      opacity: animation,      
      child: CondolenceFeedListTile(condolence: condolence, funeral: funeral),    
    ); 
  }

  Widget _createRemovedCondolenceFeedTile(Condolence condolence, Animation<double> animation) {    
    return FadeTransition(      
      // axis: Axis.vertical,      
      opacity: animation,      
      child: CondolenceFeedListTile(condolence: condolence, funeral:funeral),   
    ); 
  }
}
