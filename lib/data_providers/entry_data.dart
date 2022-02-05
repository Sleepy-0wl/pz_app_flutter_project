import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/event_entry.dart';

CollectionReference _entries = FirebaseFirestore.instance.collection('entries');

User userAuth = FirebaseAuth.instance.currentUser as User;
String userID = userAuth.uid.toString();

Future<void> addNewEntry(
  String eventID,
  String raceClass,
  int raceNumber,
  String vehicle,
  DateTime eventDate,
) async {
  await _entries.add({
    'userID': userID,
    'eventID': eventID,
    'raceClass': raceClass,
    'raceNumber': raceNumber,
    'vehicle': vehicle,
    'eventDate': eventDate.toIso8601String(),
    'entryDate': DateTime.now().toIso8601String(),
  }).catchError((error) {
    throw (error);
  });
}

Future<List<EventEntry>> getEventEntries(
  String eventID,
  String raceClass,
) async {
  List<EventEntry> eventEntries = [];
  await _entries
      .where('eventID', isEqualTo: eventID)
      .where('raceClass', isEqualTo: raceClass)
      .orderBy('entryDate')
      .get()
      .then((value) {
    for (DocumentSnapshot newDoc in value.docs) {
      eventEntries.add(
        EventEntry(
          entryID: newDoc.id,
          userID: newDoc.get('userID'),
          eventID: newDoc.get('eventID'),
          raceClass: newDoc.get('raceClass'),
          raceNumber: newDoc.get('raceNumber'),
          vehicle: newDoc.get('vehicle'),
          eventDate: DateTime.parse(newDoc.get('eventDate')),
          entryDate: DateTime.parse(newDoc.get('entryDate')),
        ),
      );
    }
  }).catchError((error) {});
  return eventEntries;
}

Future<List<EventEntry>> getUserEntries(String _id) async {
  List<EventEntry> userEntries = [];
  await _entries
      .where('userID', isEqualTo: _id)
      .orderBy('eventDate', descending: true)
      .get()
      .then((value) {
    for (DocumentSnapshot newDoc in value.docs) {
      userEntries.add(
        EventEntry(
          entryID: newDoc.id,
          userID: newDoc.get('userID'),
          eventID: newDoc.get('eventID'),
          raceClass: newDoc.get('raceClass'),
          raceNumber: newDoc.get('raceNumber'),
          vehicle: newDoc.get('vehicle'),
          eventDate: DateTime.parse(newDoc.get('eventDate')),
          entryDate: DateTime.parse(newDoc.get('entryDate')),
        ),
      );
    }
  }).catchError((error) {});
  return userEntries;
}

Future<void> deleteEntry(String entryID) async {
  await _entries.doc(entryID).delete().catchError((error) {});
}
