import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/event.dart';

// Methods for communicating with Firebase for data about stored events.

CollectionReference _events = FirebaseFirestore.instance.collection('events');

// This method adds new event in the Firebase storage. Data is modeled after class in event.dart file.
Future<void> addNewEvent(
  File image,
  String location,
  DateTime selectedDate,
  List<String> raceClasses,
) async {
  // Creates reference to path where image will be stored. Name of the image is combination of events data.
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

// This method gets specific event from Firebase defined by given id.
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

// This method returns list of all events that match given bool argument (is event finished or not).
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

// This method returns single event that is not yet finished and is closest to current date.
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

// This method returns single event that is finished and is closest to the current date.
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
