import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../screens/user_profile_screen.dart';

// Contains actions of apps AppBars.
// You can either see your profile (opens user_profile_screen.dart) or log out.
class AppBarProfile extends StatelessWidget {
  const AppBarProfile({Key? key}) : super(key: key);

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton(
      color: Theme.of(context).scaffoldBackgroundColor,
      offset: const Offset(0, 55),
      icon: const Icon(Icons.person),
      itemBuilder: (context) => [
        PopupMenuItem(
          child: TextButton.icon(
            onPressed: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      UserProfileScreen(FirebaseAuth.instance.currentUser!.uid),
                ),
              );
            },
            icon: const Icon(Icons.person),
            label: const Text('Moj profil'),
          ),
        ),
        PopupMenuItem(
          child: TextButton.icon(
            onPressed: () {
              _signOut();
              Navigator.pop(context);
            },
            icon: const Icon(Icons.door_back_door),
            label: const Text('Odjava'),
          ),
        ),
      ],
    );
  }
}
