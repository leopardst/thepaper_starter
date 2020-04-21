import 'package:flutter/material.dart';
import 'package:thepaper_starter/app/home/jobs/empty_content.dart';
import 'package:flutter/foundation.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item, Animation animation);

class CondolencesListBuilder<T> extends StatelessWidget {
  const CondolencesListBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
  }) : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;


  @override
  Widget build(BuildContext context) {
  debugPrint('snapshot: $snapshot'); //TODO Remove this
    if (snapshot.hasData) {
      final List<T> items = snapshot.data;
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent();
      }
    } else if (snapshot.hasError) {
      return EmptyContent(
        title: 'Something went wrong',
        message: 'Can\'t load items right now',
      );
    }
    return Center(child: CircularProgressIndicator());
  }

  Widget _buildList(List<T> items) {
    return AnimatedList(
      // padding: EdgeInsets.zero, // Top padding of list
      initialItemCount: items.length + 2,
      physics: NeverScrollableScrollPhysics(),
      shrinkWrap: true,      
      itemBuilder: (context, index, animation) {
        if (index == 0 || index == items.length + 1) {
          return Container(); // zero height: not visible
        }
        return itemBuilder(context, items[index - 1], animation);
      },
    );
  }
}
