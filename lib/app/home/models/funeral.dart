import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:html/parser.dart';


class FuneralGroup{
  String id; //ID of the group
  String name; // Name of the group

  FuneralGroup.fromMap(Map<dynamic, dynamic> value)
      : id = value["id"],
        name = value["name"];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
    };
  }
}

class Funeral {
  Funeral({
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.funeralDate,
    @required this.location,
    @required this.obituary,
    this.createdDate,
    this.groups,
    this.imageURL
  });

  String id;
  String firstName;
  String lastName;
  DateTime funeralDate;
  DateTime createdDate;
  String location;
  String obituary;
  String imageURL;
  List<FuneralGroup> groups;

  factory Funeral.fromMap(Map<dynamic, dynamic> value, String id) {
    final Timestamp dateTS = value['funeralDate'];
    final Timestamp createdDateTS = value['createdDate'];

    var _fgList;
    List<FuneralGroup> finalFGList = [];

    if (value["funeral_groups"]?.isEmpty ?? true) {
      finalFGList = [];
    }else{
        _fgList = value['funeral_groups'].map((item) {
        var z = Map<String, dynamic>.from(item);
        // print(z['name']);
        return FuneralGroup.fromMap(z);
      }).toList();
      print(_fgList.toString());
      finalFGList = List<FuneralGroup>.from(_fgList);

      // _fgList = value['groups'].map<FuneralGroup>((item) {
      //   debugPrint('groupitem:' + item);
      //   return FuneralGroup.fromMap(item);
      // }).ztoList();
    }

    return Funeral(
      id: id,
      firstName: value['firstName'],
      lastName: value['lastName'],
      funeralDate: dateTS.toDate(),
      location: value['location'],
      obituary: value['obituary'],
      imageURL: value['imageURL'],
      groups: finalFGList,
      createdDate: createdDateTS.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    // var funeralGroups = items.map((i) => i.toMap()).toList();

    return <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'funeralDate': Timestamp.fromDate(funeralDate), //TODO not sure if this works
      'location': location,
      'obituary': obituary,
      'imageURL': imageURL,
      'createdDate': Timestamp.fromDate(createdDate),
      // 'groups': funeralGroups,
  };
  }

  String get fullName{
    return '$firstName $lastName';
  }

  String get funeralDateAsString{
  var formatter = new DateFormat('EEEE, MMMM dd, yyyy');
  String formatted = formatter.format(funeralDate);
  return formatted;
  }

  String get funeralTimeAsString{
    var formatter = new DateFormat('h:mm a');
    String formatted = formatter.format(funeralDate);
    return formatted;
  }
  
  String get funeralFullDateAndTimeAsString{
    var formatter = new DateFormat("EEEE, MMMM d, yyyy 'at' h:mm a");
    String formatted = formatter.format(funeralDate);
    return formatted;
  }

  String get obituaryClean{
    var oTemp = obituary.replaceAll('<br>', '\n');
    var doc = parse(oTemp);
    return parse(doc.body.text).documentElement.text;
  }

  bool get emptyImage{
    if(imageURL != null && imageURL != "https:"){
      return false;
    }
    else{
      return true;
    }
  }

  DateTime get funeralDateGroupBy{
    // String formattedDate = DateFormat('EEEE, MMMM d').format(funeralDate);
    return new DateTime(funeralDate.year, funeralDate.month, funeralDate.day);
  }

  String get funeralFormattedTime{
    if(funeralDate.hour != 0)
      return new DateFormat.jm().format(funeralDate);
    else
      return "";
  }

  Widget formattedFuneralDate(){
    if (funeralDate == null){
      return Text("Please check back for date and time");
    }
    else{

      if(funeralDate.hour != 0){
        return Text(funeralFullDateAndTimeAsString);
      }
      else{
        return Text(funeralDateAsString);
      }
    }
  }



  

// if self.funeral_date.nil?
//         return I18n.t(:please_check_for_date)
//       elsif self.midnight? || self.no_time
//         return I18n.l(self.funeral_date, format: :short)
//         # return self.funeral_date.strftime "%A, %B %d, %Y"
//       else
//         return I18n.l(self.funeral_date, format: :long)
//         #return self.funeral_date.strftime "%A, %B %d, %Y at %l:%M %p"

//       end


}


//  t.string "first_name", limit: 255
//     t.string "last_name", limit: 255
//     t.datetime "funeral_date"
//     t.datetime "created_at"
//     t.datetime "updated_at"
//     t.boolean "send_condolences"
//     t.string "condolences_email", limit: 255
//     t.string "director", limit: 255
//     t.text "donations"
//     t.string "location", limit: 255
//     t.text "obituary"
//     t.text "notes"
//     t.integer "paperman_memo"