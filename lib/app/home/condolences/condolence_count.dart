import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:thepaper_starter/app/home/condolences/condolences_page.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:thepaper_starter/routing/router.gr.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';
import 'package:thepaper_starter/app/home/condolences/compose_page.dart';
import 'package:thepaper_starter/app/home/condolences/condolences_list_builder.dart';

class CondolenceCount extends StatefulWidget {
  const CondolenceCount({@required this.funeral});
  final Funeral funeral;

  @override
  State<StatefulWidget> createState() => _CondolenceCountState();
}

class _CondolenceCountState extends State<CondolenceCount> {
  bool isLiked = false; // Has sent condolences


  static const List<Color> colors = [
    Colors.red,
    Colors.green,
    Colors.blue,
  ];

  static const double minExtent = 0.2;
  static const double maxExtent = 0.6;

  bool isExpanded = false;
  double initialExtent = minExtent;
  BuildContext draggableSheetContext;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    return Column(
    children: <Widget>[
       StreamBuilder<List<Condolence>>(
        stream: database.condolencesStream(funeral: widget.funeral),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data.isNotEmpty){
            var count = snapshot.data.length; 
            var content = Intl.plural(
              count,
              one: 'Condolences from ${snapshot.data[count - 1].name}',
              two: 'Condolences from ${snapshot.data[count - 1].name} and 1 other',
              other: 'Condolences from ${snapshot.data[count - 1].name} and ${count - 1} others',
              );

            return GestureDetector(
              // onTap: () => {CondolencesPage.show(context: context, funeral: widget.funeral)},
              onTap: () => _showDialog(context),
              child: Text(content));
          }
          else{
            return Container();
          }

        }),
    ]);
  }

void _showDialog(BuildContext context) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    builder: (BuildContext context) {
      return DraggableScrollableSheet(
        maxChildSize: maxExtent,
        expand: false,
        builder: (context, scrollController) {
          return Column(
            children: <Widget>[
              Expanded(
                child: _draggableScrollableSheetBuilder(context, scrollController),
              ),
          ]);
        },
      );
    }
  );
}

  Widget _draggableScrollableSheetBuilder(
    BuildContext context,
    ScrollController scrollController,
  ) {
    draggableSheetContext = context;
    return CondolencesListBuilder(funeral: widget.funeral, scrollController: scrollController) ;

  }



}