import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/event_result.dart';

//to-do try-catch

CollectionReference results = FirebaseFirestore.instance.collection('results');

User userAuth = FirebaseAuth.instance.currentUser as User;
String userID = userAuth.uid.toString();

Future<void> addNewResult(
  String userID,
  String eventID,
  DateTime eventDate,
  int racePosition,
  int racePoints,
  String raceClass,
) async {
  await results.add({
    'userID': userID,
    'eventID': eventID,
    'eventDate': eventDate.toIso8601String(),
    'racePosition': racePosition,
    'racePoints': racePoints,
    'raceClass': raceClass,
  }).catchError((error) {});
}

Future<List<EventResult>> getEventResult(
  String eventID,
  String raceClass,
) async {
  List<EventResult> eventResults = [];
  await results
      .where('eventID', isEqualTo: eventID)
      .where('raceClass', isEqualTo: raceClass)
      .orderBy('racePosition')
      .get()
      .then((value) {
    for (DocumentSnapshot newDoc in value.docs) {
      eventResults.add(
        EventResult(
          resultID: newDoc.id,
          userID: newDoc.get('userID'),
          eventID: newDoc.get('eventID'),
          eventDate: DateTime.parse(newDoc.get('eventDate')),
          racePosition: newDoc.get('racePosition'),
          racePoints: newDoc.get('racePoints'),
          raceClass: newDoc.get('raceClass'),
        ),
      );
    }
  }).catchError((error) {});
  return eventResults;
}

Future<List<EventResult>> getUserResults(String _id) async {
  List<EventResult> userEntries = [];
  await results
      .where('userID', isEqualTo: _id)
      .orderBy('eventDate', descending: true)
      .get()
      .then((value) {
    for (DocumentSnapshot newDoc in value.docs) {
      userEntries.add(
        EventResult(
          resultID: newDoc.id,
          userID: newDoc.get('userID'),
          eventID: newDoc.get('eventID'),
          eventDate: DateTime.parse(newDoc.get('eventDate')),
          racePosition: newDoc.get('racePosition'),
          racePoints: newDoc.get('racePoints'),
          raceClass: newDoc.get('raceClass'),
        ),
      );
    }
  }).catchError((error) {});
  return userEntries;
}
