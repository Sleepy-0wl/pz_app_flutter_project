import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/event.dart';

CollectionReference _events = FirebaseFirestore.instance.collection('events');

Future<void> addNewEvent(
  File image,
  String location,
  DateTime selectedDate,
  List<String> raceClasses,
) async {
  final ref = FirebaseStorage.instance
      .ref()
      .child('event_images')
      .child('${location}_${selectedDate.month}_${selectedDate.year}.jpg');

  await ref.putFile(image).whenComplete(() => null);
  final imageUrl = await ref.getDownloadURL();

  _events.add({
    'date': selectedDate.toIso8601String(),
    'location': location,
    'imageUrl': imageUrl,
    'classes': raceClasses,
    'isFinished': false,
  }).catchError((error) {
    throw (error);
  });
}

Future<Event> getEventFromFirebase(String id) async {
  DocumentSnapshot newSnapshot =
      await _events.doc(id).get().catchError((error) {});
  Event newUser = Event(
    id: id,
    date: DateTime.parse(newSnapshot['date']),
    location: newSnapshot['location'],
    imageUrl: newSnapshot['imageUrl'],
    classes: newSnapshot['classes'],
    isFinished: newSnapshot['isFinished'],
  );
  return newUser;
}

Future<List<Event>> getEvents(bool finished) async {
  List<Event> newEvents = [];
  await _events
      .where('isFinished', isEqualTo: finished)
      .orderBy('date', descending: finished)
      .get()
      .then((snapshot) {
    for (var element in snapshot.docs) {
      newEvents.add(
        Event(
          id: element.id,
          date: DateTime.parse(element.get('date')),
          location: element.get('location'),
          imageUrl: element.get('imageUrl'),
          classes: List.castFrom(element.get('classes')),
          isFinished: element.get('isFinished'),
        ),
      );
    }
  }).catchError((error) {});
  return newEvents;
}

Future<Event> getSoonestUnfinished() async {
  return await _events
      .where('isFinished', isEqualTo: false)
      .orderBy('date', descending: false)
      .get()
      .then((snapshot) {
    QueryDocumentSnapshot newDoc = snapshot.docs.first;
    return Event(
      id: newDoc.id,
      date: DateTime.parse(newDoc.get('date')),
      location: newDoc.get('location'),
      imageUrl: newDoc.get('imageUrl'),
      classes: List.castFrom(newDoc.get('classes')),
      isFinished: newDoc.get('isFinished'),
    );
  }).catchError((error) {});
}

Future<Event> getLatestFinished() async {
  return await _events
      .where('isFinished', isEqualTo: true)
      .orderBy('date', descending: true)
      .get()
      .then((snapshot) {
    QueryDocumentSnapshot newDoc = snapshot.docs.first;
    return Event(
      id: newDoc.id,
      date: DateTime.parse(newDoc.get('date')),
      location: newDoc.get('location'),
      imageUrl: newDoc.get('imageUrl'),
      classes: List.castFrom(newDoc.get('classes')),
      isFinished: newDoc.get('isFinished'),
    );
  }).catchError((error) {});
}
