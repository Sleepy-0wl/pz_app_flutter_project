import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/event_entry.dart';

// Methods for communicating with Firebase for data about registered entries to the event(s).

CollectionReference _entries = FirebaseFirestore.instance.collection('entries');

User userAuth = FirebaseAuth.instance.currentUser as User;
String userID = userAuth.uid.toString();

// This method adds new event entry into the Firebase. Data is modeled after class in event_entry.dart file.
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

//This method returns list of all entries from Firebase for specific event and for specific race class in that event.
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

//This method returns all the entries chosen user has.
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

//This method deletes chosen entry.
Future<void> deleteEntry(String entryID) async {
  await _entries.doc(entryID).delete().catchError((error) {});
}
