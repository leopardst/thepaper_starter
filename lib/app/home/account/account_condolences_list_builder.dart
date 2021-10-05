import 'package:flutter/material.dart';
import 'package:thepaper_starter/app/home/jobs/empty_content.dart';
import 'package:flutter/foundation.dart';

typedef ItemWidgetBuilder<T> = Widget Function(BuildContext context, T item);

class AccountCondolencesListBuilder<T> extends StatelessWidget {
  const AccountCondolencesListBuilder({
    Key? key,
    required this.snapshot,
    required this.itemBuilder,
    this.dontScroll = false,
  }) : super(key: key);
  final AsyncSnapshot<List<T>> snapshot;
  final ItemWidgetBuilder<T> itemBuilder;
  final bool dontScroll;

  @override
  Widget build(BuildContext context) {
  debugPrint('snapshot: $snapshot'); //TODO Remove this
    if (snapshot.hasData) {
      final List<T> items = snapshot.data!.reversed.toList();
      if (items.isNotEmpty) {
        return _buildList(items);
      } else {
        return EmptyContent(
          title: "No condolences",
          message: "You haven't left any condolences yet"
        );
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
    return ListView.separated(
        separatorBuilder: (BuildContext context, int index) {
          if (index == 0)
            return Container();
          else
            return Divider();
        },
      padding: EdgeInsets.zero, // Top padding of list
      itemCount: items.length + 2,
      physics:  NeverScrollableScrollPhysics(),
      shrinkWrap: true,
      itemBuilder: (context, index) {
        if (index == 0)
          return Container(); // zero height: not visible
        if(index == items.length + 1){
          return Container(
            margin: EdgeInsets.fromLTRB(20.0, 30.0, 20.0, 30.0),
          );
        }
        return itemBuilder(context, items[index - 1]);
      },
    );
  }
}
