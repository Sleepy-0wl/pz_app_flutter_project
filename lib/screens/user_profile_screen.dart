import 'package:flutter/material.dart';

import '../widgets/user_entries.dart';
import '../widgets/user_profile_data.dart';

// This screen displays data about user with given id.
// Can be opened from appbar_profile.dart (PopupMenuButton) or by pressing on any user name in event_data_table.dart.
// It is separated into two widgets. UserProfileData displays users data.
// UserEntries displays users entries and results.
class UserProfileScreen extends StatefulWidget {
  final String _userID;

  const UserProfileScreen(this._userID, {Key? key}) : super(key: key);
  @override
  State<UserProfileScreen> createState() => _UserProfileScreenState();
}

class _UserProfileScreenState extends State<UserProfileScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profil korisnika',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        padding: const EdgeInsets.only(top: 10),
        width: double.infinity,
        child: Column(
          children: [
            SizedBox(
              width: 360,
              height: 200,
              child: Card(
                elevation: 5,
                child: UserProfileData(widget._userID),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SingleChildScrollView(
              child: Container(
                width: double.infinity,
                height: 420,
                padding: const EdgeInsets.all(8),
                child: UserEntries(widget._userID),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
