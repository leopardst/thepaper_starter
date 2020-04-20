import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Funeral {
  Funeral({
    @required this.id,
    @required this.firstName,
    @required this.lastName,
    @required this.funeralDate,
    @required this.location,
    @required this.obituary,
    this.imageURL
  });

  String id;
  String firstName;
  String lastName;
  DateTime funeralDate;
  String location;
  String obituary;
  String imageURL;

  factory Funeral.fromMap(Map<dynamic, dynamic> value, String id) {
    final Timestamp dateTS = value['funeralDate'];
    return Funeral(
      id: id,
      firstName: value['firstName'],
      lastName: value['lastName'],
      funeralDate: dateTS.toDate(),
      location: value['location'],
      obituary: value['obituary'],
      imageURL: value['imageURL'],
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'first_name': firstName,
      'last_name': lastName,
      'funeral_date': funeralDate.millisecondsSinceEpoch, //TODO not sure if this works
      'location': location,
      'obituary': obituary,
      'imageURL': imageURL,
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
    var formatter = new DateFormat('kk:mm');
    String formatted = formatter.format(funeralDate);
    return formatted;
  }
  
    String get funeralFullDateAndTimeAsString{
    var formatter = new DateFormat("EEEE, MMMM d, yyyy 'at' h:mm a");
    String formatted = formatter.format(funeralDate);
    return formatted;
  }




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