import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:grouped_list/grouped_list.dart';
import 'package:intl/intl.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/app/home/funerals/funeral_details_page.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/routing/router.gr.dart';
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
    return Material(
      child: CupertinoPageScaffold(
        navigationBar: CupertinoNavigationBar(
            leading: Container(), middle: Text('Calendar')),
        child: StreamBuilder<List<Funeral>>(
            stream: database.funeralsStreamAfterDate(
                afterDate: new DateTime(
                    DateTime.now().year,
                    DateTime.now().month,
                    DateTime.now().day)), // trying to get last midnight to include today
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasData) {
                final List<Funeral> elements = snapshot.data;
                return SafeArea(
                    bottom: false,
                    child: GroupedListView<Funeral, DateTime>(
                      padding: EdgeInsets.all(20.0),
                      controller: scrollController,
                      shrinkWrap: true,
                      elements: elements,
                      // useStickyGroupSeparators: true,
                      groupBy: (Funeral f) => f.funeralDateGroupBy,
                      groupSeparatorBuilder: (value) => Padding(
                        padding: EdgeInsets.only(top: 10.0),
                        child: Text(
                          DateFormat('EEEE, MMMM d').format(value),
                          style: TextStyle(fontWeight: FontWeight.w600)
                        ),
                      ),
                      itemBuilder: (context, element) {
                        return ListTile(
                          onTap: () => {
                            Navigator.pop(context),
                            FuneralDetailsPage.show(context, element)
                          },
                          title: Text(element.fullName),
                          trailing: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(element.funeralFormattedTime),
                            ]),
                        );
                      },
                      order: GroupedListOrder.ASC,
                    ));
              }
            }),
      ),
    );
  }
}
