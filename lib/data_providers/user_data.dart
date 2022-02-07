import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user.dart';

// Methods for communicating with Firebase for data about registered users.

CollectionReference users = FirebaseFirestore.instance.collection('users');

// This method adds new user to the Firebase storage and simultaneously registers user in Firebase Authentication.
// Data is modeled after class in user.dart file.
Future<void> addNewUser(
  String email,
  String password,
  String name,
  String surname,
  DateTime dateOfBirth,
  String country,
  File image,
) async {
  final _auth = FirebaseAuth.instance;
  UserCredential _authResult;

  // Creates new user in Firebase Auth
  _authResult = await _auth.createUserWithEmailAndPassword(
      email: email, password: password);

  // Creates reference to path where image will be stored. Name of the image is users id.
  final ref = FirebaseStorage.instance
      .ref()
      .child('user_images')
      .child(_authResult.user!.uid + '.jpg');

  await ref.putFile(image).whenComplete(() => null);
  final imageUrl = await ref.getDownloadURL();

  // Adds new user to storage.
  // .doc().set() is used instead of .add() so that same userID can be used in both Firebase Auth and as document id in storage.
  users.doc(_authResult.user!.uid).set({
    'email': email,
    'name': name,
    'surname': surname,
    'dateOfBirth': dateOfBirth.toIso8601String(),
    'country': country,
    'imageUrl': imageUrl,
    'isAdmin': false,
  }).catchError((error) {});
}

// Method for logging user in.
Future<void> logUserIn(String email, String password) async {
  final _auth = FirebaseAuth.instance;
  UserCredential _authResult = await _auth
      .signInWithEmailAndPassword(email: email, password: password)
      .catchError((error) {});
}

// Method that reads data for single user specified by id.
Future<AppUser> readUserData(String id) async {
  DocumentSnapshot newSnapshot =
      await users.doc(id).get().catchError((error) {});
  AppUser newUser = AppUser(
    id: id,
    email: newSnapshot['email'],
    name: newSnapshot['name'],
    surname: newSnapshot['surname'],
    dateOfBirth: DateTime.parse(newSnapshot['dateOfBirth']),
    country: newSnapshot['country'],
    imageUrl: newSnapshot['imageUrl'],
    isAdmin: newSnapshot['isAdmin'],
  );
  return newUser;
}

// Method for updating users data
Future<void> updateUserData(
  String id,
  String name,
  String surname,
  DateTime dateOfBirth,
  String country,
  File image,
) async {
  final ref =
      FirebaseStorage.instance.ref().child('user_images').child(id + '.jpg');
  await ref.delete().catchError((error) {});
  await ref.putFile(image).whenComplete(() => null).catchError((error) {});
  final imageUrl = await ref.getDownloadURL().catchError((error) {});

  users.doc(id).update({
    'name': name,
    'surname': surname,
    'dateOfBirth': dateOfBirth.toIso8601String(),
    'country': country,
    'imageUrl': imageUrl,
  }).catchError((error) {});
}
