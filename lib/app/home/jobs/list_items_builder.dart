import 'package:flutter/material.dart';
import 'package:thepaper_starter/app/home/jobs/empty_content.dart';
import 'package:flutter/foundation.dart';
import 'package:thepaper_starter/constants/text_themes.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class ListItemsBuilder<T> extends StatelessWidget {
  const ListItemsBuilder({
    Key? key,
    required this.snapshot,
    required this.itemBuilder,
    this.dontScroll = false,
    this.showFooter = true,
  }) : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final bool dontScroll;
  final bool showFooter;

  @override
  Widget build(BuildContext context) {
  debugPrint('snapshot: $snapshot'); //TODO Remove this
    if (snapshot.hasData) {
      final List<T> items = snapshot.data!;
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
      itemCount: items.length + (showFooter ? 2: 1),
      physics: dontScroll ? NeverScrollableScrollPhysics() : AlwaysScrollableScrollPhysics(),
      shrinkWrap: dontScroll ? true : false,
      itemBuilder: (context, index) {
        if (index == 0)
          return Container(); // zero height: not visible
        if(index == items.length + 1){
          return Container(
            margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
            child: Text("You can find listings older than 30 days in Search", style: TextThemes.helperText, textAlign: TextAlign.center,)
          );
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
