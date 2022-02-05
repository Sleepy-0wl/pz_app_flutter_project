import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user.dart';

CollectionReference users = FirebaseFirestore.instance.collection('users');

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

  _authResult = await _auth.createUserWithEmailAndPassword(
      email: email, password: password);
  final ref = FirebaseStorage.instance
      .ref()
      .child('user_images')
      .child(_authResult.user!.uid + '.jpg');

  await ref.putFile(image).whenComplete(() => null);
  final imageUrl = await ref.getDownloadURL();
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

Future<void> logUserIn(String email, String password) async {
  final _auth = FirebaseAuth.instance;
  UserCredential _authResult = await _auth
      .signInWithEmailAndPassword(email: email, password: password)
      .catchError((error) {});
}

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
