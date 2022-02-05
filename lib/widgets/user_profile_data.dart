import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/user.dart';
import '../data_providers/user_data.dart';
import '../screens/user_update_screen.dart';

class UserProfileData extends StatefulWidget {
  final String _userID;

  const UserProfileData(this._userID, {Key? key}) : super(key: key);

  @override
  _UserProfileDataState createState() => _UserProfileDataState();
}

class _UserProfileDataState extends State<UserProfileData> {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AppUser>(
        future: readUserData(widget._userID),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final user = snapshot.data!;
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Column(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: NetworkImage(
                          user.imageUrl.toString(),
                        ),
                      ),
                      if (FirebaseAuth.instance.currentUser!.uid ==
                          widget._userID)
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserUpdateScreen(user),
                              ),
                            );
                          },
                          child: const Text('PROMIJENI'),
                        ),
                    ],
                  ),
                  SizedBox(
                    width: 200,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const SizedBox(
                          height: 20,
                        ),
                        Text(
                          user.name + ' ' + user.surname,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(user.country),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(
                            "${user.dateOfBirth.day}.${user.dateOfBirth.month}.${user.dateOfBirth.year}."),
                        const SizedBox(
                          height: 10,
                        ),
                        Text(user.email),
                      ],
                    ),
                  )
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Greška u dohvaćanju podataka'),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        });
  }
}
