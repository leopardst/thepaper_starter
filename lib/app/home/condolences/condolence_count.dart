import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/constants/strings.dart';
import 'package:thepaper_starter/constants/text_themes.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
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
    final user = Provider.of<AppUser>(context, listen:false);
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
            var nameContent = getNames(snapshot.data, count, user);
            return GestureDetector(
              onTap: () => _showDialog(context),
              child: Text(Strings.viewCondolences, style: TextThemes.actionTitle),
            );
          }
          else{
            return Container();
          }

        }),
    );
  }

String getNames(List<Condolence> data, int count, AppUser user){

  var content = "";

  if(data.length == 1 && userHasGivenCondolences){ // Only you have given condolences
    content = "";
  }
  else{
    
    var name1;

    if(data.length == 1){
      name1 = data[count - 1].name;
    }
    else{
      if(data[count - 1].id != user.uid){
        name1 = data[count - 1].name;
      }
      else{
        name1 = data[count - 2].name;
      }

    }

    if(userHasGivenCondolences){
    content = Intl.plural(
        count,
        one: '',
        other: '$name1 ',
      );
    }
    else{
      var name2 = "";
      if(count >= 2){
        name2 = data[count - 2].name;
      }

      content = Intl.plural(
        count,
        one: '${data[count - 1].name}',
        two: '${data[count - 1].name} and $name2',
        other: '${data[count - 1].name} ',
      );
    }

    
  }

  return content;
}

String andOthers(bool userHasGivenCondolences, int count){

  String text = "";
  if(count >= 3 )
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
    shape: RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(20.0)),
    ),
    context: context,
    useRootNavigator: true,
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