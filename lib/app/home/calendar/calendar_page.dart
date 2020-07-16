import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/app/home/funerals/funeral_details_page.dart';
import 'package:thepaper_starter/app/home/jobs/empty_content.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/constants/text_themes.dart';
import 'package:thepaper_starter/routing/router.gr.dart';
import 'package:thepaper_starter/services/analytics_service.dart';
import 'package:thepaper_starter/services/firestore_database.dart';

class CalendarPage extends StatelessWidget {
  final ScrollController scrollController;

  const CalendarPage({Key key, this.scrollController}) : super(key: key);

  // static Future<void> show({BuildContext context}) async {
  //   // await Navigator.of(context, rootNavigator: true).pushNamed(
  //   //   Router.calendarPage
  //   // );
  //   await Navigator.of(context).push(MaterialWithModalsPageRoute());

  // }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);

    final analyticsService = Provider.of<AnalyticsService>(context, listen: false);
    analyticsService.logViewCalendar();

    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            automaticallyImplyLeading: false,
            middle: Text('Upcoming Services')),
        child: StreamBuilder<List<Funeral>>(
            initialData: [],
            stream: database.funeralsStreamAfterDate(
                daysAfter: 0), // trying to get last midnight to include today
            builder: (context, snapshot) {
              print('state:' + snapshot.connectionState.toString());
              if (snapshot.hasData) {
                final List<Funeral> items = snapshot.data;
                if (items.isNotEmpty) {
                  return _buildList(items);
                } else {
                  return EmptyContent(
                    title: "No funerals",
                    message: "Check back later for updated schedule",
                  );
                }
              } else if (snapshot.hasError) {
                return EmptyContent(
                  title: 'Something went wrong',
                  message: 'Can\'t load items right now',
                );
              }
              return Center(child: CircularProgressIndicator());
            }),
      ),
    );
  }

  Widget _buildList(List<Funeral> items){
    return SafeArea(
      bottom: false,
      child: GroupedListView<Funeral, DateTime>(
        padding: EdgeInsets.all(20.0),
        controller: scrollController,
        shrinkWrap: true,
        elements: items,
        // useStickyGroupSeparators: true,
        groupBy: (Funeral f) => f.funeralDateGroupBy,
        groupSeparatorBuilder: (value) => groupSeparator(value),
        itemBuilder: (context, item) {
          return ListTile(
            onTap: () => {
              // Navigator.pop(context),
              FuneralDetailsPage.show(context, item)
            },
            title: Text(item.fullName),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Text(item.funeralFormattedTime),
              ]),
          );
        },
        order: GroupedListOrder.ASC,
      )); 
  }

  Widget groupSeparator(DateTime value){
    if (value.difference(new DateTime(
      DateTime.now().year,
      DateTime.now().month,
      DateTime.now().day)).inDays == 0)
      {
      return Text("Today", style: TextStyle(fontWeight: FontWeight.w600));
   } else{
    return Padding(
            padding: EdgeInsets.only(top: 10.0),
            child: Text(
              DateFormat('EEEE, MMMM d').format(value),
              style: TextThemes.smallTitle,
            )
    );
   }
  }
}
