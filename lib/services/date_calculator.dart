import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// burada dart.dev'in intl paketini kullandım
class DateCalculator extends ChangeNotifier{
  static Timestamp fromDatetimeToTimestamp() {

    Timestamp fromDateToTimeStamp = Timestamp.fromDate(DateTime.now());
    return fromDateToTimeStamp;
  }

  DateTime fromTimestampToDateTime(Timestamp timestamp) {

    return DateTime.fromMillisecondsSinceEpoch(timestamp.seconds * 1000);

  }

  static String datetimeToString(DateTime dateTime) {
    String datetimeToString = DateFormat('dd/ MM/ yyy, HH:mm').format(dateTime);
    return datetimeToString;
  }


}
