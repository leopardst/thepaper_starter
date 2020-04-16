import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:thepaper_starter/app/home/models/condolence.dart';
import 'package:thepaper_starter/app/home/models/funeral.dart';
import 'package:thepaper_starter/common_widgets/platform_exception_alert_dialog.dart';
import 'package:thepaper_starter/services/firestore_database.dart';
import 'package:thepaper_starter/routing/router.gr.dart';
import 'package:thepaper_starter/services/firebase_auth_service.dart';

class CondolenceButton extends StatefulWidget {
  const CondolenceButton({@required this.funeral});
  final Funeral funeral;

  @override
  State<StatefulWidget> createState() => _CondolenceButtonState();
}

class _CondolenceButtonState extends State<CondolenceButton> {
  bool isLiked = false; // Has sent condolences

  _pressed(){
    setState(() {
      isLiked = !isLiked;
    });
  }

  @override
  void initState() {
    super.initState();
    final database = Provider.of<FirestoreDatabase>(context, listen: false);
//     return StreamBuilder<Job>(
//       stream: database.jobStream(jobId: job.id),
    // check if currently liked?
  }

  Condolence _condolenceFromState() {
    final user = Provider.of<User>(context, listen:false);
    // final uid = user.uid;
    final name = user.email;
    final id = documentIdFromCurrentDate();
      
    return Condolence(
      id: id,
      // uid: uid,
      name: name,
    );
  }
  

  // Entry _entryFromState() {
  //   final start = DateTime(_startDate.year, _startDate.month, _startDate.day,
  //       _startTime.hour, _startTime.minute);
  //   final end = DateTime(_endDate.year, _endDate.month, _endDate.day,
  //       _endTime.hour, _endTime.minute);
  //   final id = widget.entry?.id ?? documentIdFromCurrentDate();
  //   return Entry(
  //     id: id,
  //     jobId: widget.job.id,
  //     start: start,
  //     end: end,
  //     comment: _comment,
  //   );
  // }

  // Future<void> _setEntryAndDismiss(BuildContext context) async {
  //   try {
  //     final database = Provider.of<FirestoreDatabase>(context, listen: false);
  //     final entry = _entryFromState();
  //     await database.setEntry(entry);
  //     Navigator.of(context).pop();
  //   } on PlatformException catch (e) {
  //     PlatformExceptionAlertDialog(
  //       title: 'Operation failed',
  //       exception: e,
  //     ).show(context);
  //   }
  // }

  Future<void> _toggleCondolence(BuildContext context, String funeralId) async {
    try {
      final database = Provider.of<FirestoreDatabase>(context, listen: false);
      final condolence = _condolenceFromState();
      await database.setCondolence(condolence, funeralId);
      setState(() {
        isLiked = !isLiked;
      });
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(
        isLiked ? Icons.favorite : Icons.favorite_border,
        color: isLiked ? Colors.red : Colors.grey 
       ), 
      onPressed: () => _toggleCondolence(context, widget.funeral.id),
    );
    
  }
  
}