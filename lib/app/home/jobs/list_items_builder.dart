import 'package:flutter/material.dart';
import 'package:thepaper_starter/app/home/jobs/empty_content.dart';
import 'package:flutter/foundation.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({
    Key key,
    @required this.snapshot,
    @required this.itemBuilder,
    this.listHeader,
    this.dontScroll = false,
  }) : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final String listHeader;
  final bool dontScroll;

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
    return ListView.builder(
      padding: EdgeInsets.zero, // Top padding of list
      itemCount: items.length + 2,
      physics: dontScroll ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
      shrinkWrap: dontScroll ? true : false,
      itemBuilder: (context, index) {
        if (index == 0 || index == items.length + 1) {
          return Container(); // zero height: not visible
        }
        if (index == 1 && listHeader != null){
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: Text(
              listHeader,
              style: Theme.of(context).textTheme.headline,
            ),
          );
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
