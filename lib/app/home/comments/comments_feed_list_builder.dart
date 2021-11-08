import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';
import 'package:thepaper_starter/app/home/comments/comments_feed_list_tile.dart';
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

class CommentsFeedListBuilder extends StatelessWidget {
  const CommentsFeedListBuilder({
    Key? key,
    // @required this.snapshot,
    // @required this.itemBuilder,
    required this.funeral,
  }) : super(key: key);
  // final AsyncSnapshot<List<T>> snapshot;
  // final ItemWidgetBuilder<T> itemBuilder;
  final Funeral? funeral;
  

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return FutureBuilder<List>(
      future: database.commentsList(funeral: funeral!),
      builder: (BuildContext context, AsyncSnapshot snapshot) {
        debugPrint('comment snapshot: $snapshot'); //TODO Remove this
        if (snapshot.hasData) {
          final List<Comment>? items = snapshot.data;
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

  Widget _buildList(BuildContext context, List<Comment>? initialItems) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    final stream = database.commentsStream(funeral: funeral!);
    
    return Padding(
      padding: const EdgeInsets.only(top: 20.0),
      child: EmptiableList(
          listStream: stream,
          // placeholder: EmptyContent(),
          list: AnimatedStreamList<Comment>(
            streamList: stream,
            // initialList: initialItems,
            scrollPhysics: NeverScrollableScrollPhysics(),
            shrinkWrap: true, 
            itemBuilder: (List<Comment> items, index, context, animation) =>      
              _createCondolenceFeedTile(items[index], animation),      
            itemRemovedBuilder: (List<Comment> items, index, context, animation) =>  
              _createRemovedCondolenceFeedTile(items[index], animation), 
        ),
      ),
    );
  }

  Widget _createCondolenceFeedTile(Comment comment, Animation<double> animation) {    
    return FadeTransition(      
      // axis: Axis.vertical,      
      opacity: animation,      
      child: CommentsFeedListTile(comment: comment, funeral: funeral),    
    ); 
  }

  Widget _createRemovedCondolenceFeedTile(Comment comment, Animation<double> animation) {    
    return FadeTransition(      
      // axis: Axis.vertical,      
      opacity: animation,      
      child: CommentsFeedListTile(comment: comment, funeral:funeral),   
    ); 
  }
}
