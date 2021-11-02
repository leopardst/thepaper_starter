import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/app/home/funerals/funeral_list_tile.dart';
import 'package:thepaper_starter/app/home/jobs/empty_content.dart';
import 'package:thepaper_starter/app/home/jobs/list_items_builder.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:google_fonts/google_fonts.dart';

class FuneralsPage extends StatefulWidget {

  @override
  _FuneralsPageState createState() => _FuneralsPageState();
}

class _FuneralsPageState extends State<FuneralsPage> {
  DateFormat format = DateFormat('EE, MMM d');

  bool showCalendar = false;
  DateTime? selectedDate;
  static double calendarIconHeight = 65.0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(0.0),
        child: AppBar(
          // title: Text(Strings.funerals),
          elevation: 0.0,
        ),
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return CustomScrollView(
      slivers: <Widget>[
        SliverAppBar(
          floating: true,
          snap: true,
          flexibleSpace: FlexibleSpaceBar(
            centerTitle: false,
            titlePadding: EdgeInsetsDirectional.only(start: 20, bottom: 15),
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(
                  'the paper',
                  style: GoogleFonts.notoSerif(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.calendar_today),
                  tooltip: 'Calendar',
                  onPressed: () {
                    setState(() {
                      showCalendar = !showCalendar;
                      selectedDate = null;
                    });
                  },
                ),
              ],
            ),
          ),
        ),
        SliverList(
          delegate: SliverChildListDelegate(
            [
              StreamBuilder<List<Funeral>>(
                stream: database.funeralsStreamSinceDaysAgo(
                  daysAgo: 30,
                ),
                // stream: database.funeralsStream(),
                builder: (context, snapshot) {
                  return StreamBuilder<List<Funeral>>(
                    initialData: [],
                    stream: database.funeralsStreamAfterDate(
                        daysAfter: 0), // trying to get last midnight to include today
                    builder: (context, AsyncSnapshot<List<Funeral>> filtered) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          _calendarView(filtered),
                          AnimatedCrossFade(
                              firstChild: ListItemsBuilder<Funeral>(
                                snapshot: snapshot,
                                dontScroll: true,
                                itemBuilder: (context, funeral) => FuneralListTile(
                                  funeral: funeral,
                                  hero: '',
                                ),
                              ),
                              secondChild: buildFilteredList(filtered),
                              crossFadeState: selectedDate != null
                                  ? CrossFadeState.showSecond
                                  : CrossFadeState.showFirst,
                              duration: Duration(milliseconds: 300),
                          )
                        ],
                      );
                    },
                  );
                },
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget _buildCalendarList(AsyncSnapshot<List<Funeral>> snapshot) {
    if (selectedDate == null) {
      return Container();
    } else {
      List<Funeral> filtered = snapshot.data!.where((element) =>
      format.format(element.funeralDate!) == format.format(selectedDate!)
      ).toList();
      return ListItemsBuilder<Funeral>(
        snapshot: AsyncSnapshot.withData(ConnectionState.done, filtered),
        showFooter: false,
        dontScroll: true,
        itemBuilder: (context, funeral) => FuneralListTile(
          funeral: funeral,
          hero: selectedDate.toString(),
        ),
      );
    }
  }

  Widget _calendarView(AsyncSnapshot<List<Funeral>> snapshot) {
    List<Widget> dateButtons = [];
    dateButtons.add(ElevatedButton(
      onPressed: () {
        setState(() {
          selectedDate = null;
        });
      },
      child: Text(
        'All',
        style: TextStyle(
          // fontWeight: FontWeight.bold,
          color: selectedDate == null ? Colors.white: Colors.black,
        ),
        textAlign: TextAlign.center,
        ),
        style: ElevatedButton.styleFrom(
          primary: selectedDate == null ? Colors.black: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
        ),
      ),
    );

    if (snapshot.hasData) {
      List<DateTime> dateTimes = snapshot.data!.where((element) =>
      element.funeralDate != null).map((e) => e.funeralDate!).toSet().toList();
      dateTimes.sort((d1, d2) => d1.compareTo(d2));
      for (DateTime dt in dateTimes) {
        dateButtons.add(
          Padding(
            padding: EdgeInsets.only(left: 16),
            child: ElevatedButton(
              onPressed: () {
                setState(() {
                  selectedDate = dt;
                });
              },
              child: Text(
                format.format(dt),
                style: TextStyle(
                  // fontWeight: FontWeight.bold,
                  color: selectedDate == dt ? Colors.white: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              style: ElevatedButton.styleFrom(
                primary: selectedDate == dt ? Colors.black: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(18),
                ),
              ),
             
            ),
          ),
        );
      }
    }
    return AnimatedContainer(
      duration: Duration(milliseconds: 200),
      height: showCalendar ? 50: 0,
      child: Container(
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.symmetric(
            horizontal: 24,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: List.generate(dateButtons.length, (index) {
              return dateButtons[index];
            }),
          ),
        ),
      ),
    );
  }

  Widget buildFilteredList(AsyncSnapshot<List<Funeral>> snapshot) {
    if (snapshot.hasData) {
      final List<Funeral> items = snapshot.data!;
      if (items.isNotEmpty) {
        return _buildCalendarList(snapshot);
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
  }
}
