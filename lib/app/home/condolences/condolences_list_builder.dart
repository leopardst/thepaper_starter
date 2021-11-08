import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:thepaper_starter/app/home/condolences/condolence_list_tile.dart';
// import 'dart:async';


import 'package:thepaper_starter/app/home/jobs/empty_content.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';

import 'package:animated_stream_list/animated_stream_list.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:thepaper_starter/app/home/condolences/emptiable_list.dart';

// typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item, Animation animation);

class CondolencesListBuilder extends StatelessWidget {
  const CondolencesListBuilder({
    Key? key,
    // @required this.snapshot,
    // @required this.itemBuilder,
    required this.funeral,
    required this.scrollController,

  }) : super(key: key);
  // final AsyncSnapshot<List<T>> snapshot;
  // final ItemWidgetBuilder<T> itemBuilder;
  final Funeral? funeral;
  final ScrollController scrollController;


  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return FutureBuilder<List>(
      future: database.condolencesList(funeral: funeral!),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        debugPrint('condolence snapshot: $snapshot'); //TODO Remove this
        if (snapshot.hasData) {
          final List<Condolence>? items = snapshot.data;
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

  Widget _buildList(BuildContext context, List<Condolence>? initialItems) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    final stream = database.condolencesStream(funeral: funeral!);
    final user = Provider.of<AppUser>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.fromLTRB(10.0, 25.0, 10.0, 0.0),
      child: AnimatedStreamList<Condolence>(
        scrollController: scrollController,
        streamList: stream,
        // initialList: initialItems,
        // scrollPhysics: NeverScrollableScrollPhysics(),
        // shrinkWrap: true, 
        itemBuilder: (List<Condolence> items, index, context, animation) =>      
          _createCondolenceTile(items[index], animation),      
        itemRemovedBuilder: (List<Condolence> items, index, context, animation) =>  
          _createRemovedCondolenceTile(items[index], animation), 
      ),
    );
  }

  Widget _createCondolenceTile(Condolence condolence, Animation<double> animation) {    
    return FadeTransition(          
      opacity: animation,      
      child: CondolenceListTile(condolence: condolence, funeral: funeral),    
    ); 
  }

  Widget _createRemovedCondolenceTile(Condolence condolence, Animation<double> animation) {    
    return FadeTransition(      
      // axis: Axis.vertical,      
      opacity: animation,      
      child: CondolenceListTile(condolence: condolence, funeral:funeral),   
    ); 
  }
}
