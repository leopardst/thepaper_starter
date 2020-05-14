import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
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


  static const double minExtent = 0.2;
  static const double maxExtent = 0.9;

  bool isExpanded = false;
  bool userHasGivenCondolences = false;
  double initialExtent = minExtent;
  BuildContext draggableSheetContext;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
    // final user = Provider.of<User>(context, listen:false);
    var condolenceSnapshot = Provider.of<Condolence>(context);
    if(condolenceSnapshot != null){
      userHasGivenCondolences = true;
    }
    else{
      userHasGivenCondolences = false;
    }

    return Container(
      // constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width - 40.0), 
      // width: MediaQuery.of(context).size.width - 40.0,
      child:
       StreamBuilder<List<Condolence>>(
        stream: database.condolencesStream(funeral: widget.funeral),
        builder: (context, snapshot) {
          if(snapshot.hasData && snapshot.data.isNotEmpty){
            var count = snapshot.data.length; 
            var nameContent;

           if(snapshot.data.length == 1 && userHasGivenCondolences){
              // nameContent = snapshot.data[count - 1].name;
              nameContent = "";
            }
            else{
              nameContent = Intl.plural(
                  count,
                  one: '${snapshot.data[count - 1].name}',
                  two: '${snapshot.data[count - 1].name} and ${snapshot.data[count - 2].name}',
                  other: '${snapshot.data[count - 1].name} ',
                );

              // if(userHasGivenCondolences){
              //   nameContent = Intl.plural(
              //     count,
              //     one: 'You',
              //     two: 'You and ${snapshot.data[count - 1].name}',
              //     other: 'You and others',
              //   );
              // }
              // else{
              //   nameContent = Intl.plural(
              //     count,
              //     one: '${snapshot.data[count - 1].name}',
              //     two: '${snapshot.data[count - 1].name} and ${snapshot.data[count - 2].name}',
              //     other: '${snapshot.data[count - 1].name} and others',
              //   );
              // }
            }
            
            return GestureDetector(
              // onTap: () => {CondolencesPage.show(context: context, funeral: widget.funeral)},
              onTap: () => _showDialog(context),
              child: Wrap(
                direction: Axis.horizontal,
                children: <Widget>[
                  Text(
                    "Condolences from "
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 200),
                    child:
                      Text(youCondolenceText(userHasGivenCondolences, count),
                        key: ValueKey<int>(userHasGivenCondolences ? 0 : 1),
                        style: TextStyle(fontWeight: FontWeight.w600),
                      ),
                  ),
                  Text(
                    nameContent,
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                  Text(
                    andOthers(userHasGivenCondolences, count),
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                 
                ]
              ),
              // child: AnimatedSwitcher(
              //   duration: const Duration(milliseconds: 200),
              //   child: RichText(
              //     key: ValueKey<int>(userHasGivenCondolences ? 0 : 1),
              //     text: TextSpan(
              //       // style: defaultStyle,
              //       style: TextStyle(fontWeight: FontWeight.normal, color: Colors.black, fontSize: 14.0),
              //       text: "Condolences from ",
              //       children: <TextSpan>[
              //         TextSpan(text: nameContent, style: TextStyle(fontWeight: FontWeight.w600)),
              //       ],
              //     )
              //   ),
              // )
            );
          }
          else{
            return Container();
          }

        }),
    );
  }

String andOthers(bool userHasGivenCondolences, int count){

  String text = "";
  if((count >= 3 && !userHasGivenCondolences) || (count >= 4 && userHasGivenCondolences) )
  {
    text = "and others";
  }
  
  return text;

}

String youCondolenceText(bool userHasGivenCondolences, int count){

  String s1 = "";
  String s2 = "";

  if(userHasGivenCondolences){
    s1 = "You";
    if(count == 2){
      s2 = " and ";
    }
    if(count >= 3){
      s2 = ", ";
    }
  }
  
  return s1+s2;



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