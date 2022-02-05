import 'package:flutter/material.dart';

import '../widgets/update_user.dart';
import '../models/user.dart';

class UserUpdateScreen extends StatefulWidget {
  final AppUser _user;

  const UserUpdateScreen(this._user, {Key? key}) : super(key: key);

  @override
  _UserUpdateScreenState createState() => _UserUpdateScreenState();
}

class _UserUpdateScreenState extends State<UserUpdateScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 140),
            Center(
              child: Container(
                height: 560,
                width: 320,
                color: Theme.of(context).scaffoldBackgroundColor,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      UpdateUser(widget._user),
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: const Text('Odustani')),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
