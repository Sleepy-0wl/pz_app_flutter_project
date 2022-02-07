import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../screens/event_list_screen.dart';
import '../screens/new_event_screen.dart';
import '../data_providers/user_data.dart';
import '../models/user.dart';

// Drawer widget of this app.
// Contains ListView of tiles which lead to event_list_screen.dart.
// If user is admin, tile which leads to new_event_screen.dart is also visible.
class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String uid = FirebaseAuth.instance.currentUser!.uid;

    return FutureBuilder<AppUser>(
        future: readUserData(uid),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final _isAdmin = snapshot.data!.isAdmin;
            return Drawer(
              backgroundColor: Theme.of(context).scaffoldBackgroundColor,
              child: ListView(
                padding: EdgeInsets.zero,
                children: [
                  AppBar(
                    title: const Text(
                      'Eventovi',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    automaticallyImplyLeading: false,
                  ),
                  Divider(
                    color: Theme.of(context).primaryColor,
                  ),
                  ListTile(
                      leading: const Icon(Icons.flag_sharp),
                      title: const Text('Nadolazeći'),
                      iconColor: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryColor,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EventListScreen(false, _isAdmin),
                          ),
                        );
                      }),
                  Divider(
                    color: Theme.of(context).primaryColor,
                  ),
                  ListTile(
                      leading: const Icon(Icons.flag_outlined),
                      title: const Text('Završeni'),
                      iconColor: Theme.of(context).primaryColor,
                      textColor: Theme.of(context).primaryColor,
                      onTap: () {
                        Navigator.pop(context);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                EventListScreen(true, _isAdmin),
                          ),
                        );
                      }),
                  Divider(
                    color: Theme.of(context).primaryColor,
                  ),
                  if (_isAdmin)
                    ListTile(
                        leading: const Icon(Icons.add),
                        title: const Text('Novi event'),
                        iconColor: Theme.of(context).primaryColor,
                        textColor: Theme.of(context).primaryColor,
                        onTap: () {
                          Navigator.pop(context);
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const NewEventScreen(),
                            ),
                          );
                        }),
                  if (_isAdmin)
                    Divider(
                      color: Theme.of(context).primaryColor,
                    ),
                ],
              ),
            );
          } else if (snapshot.hasError) {
            return const Center(
              child: Text(
                'Došlo je do greške',
                style: TextStyle(color: Colors.white),
              ),
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.orange,
              ),
            );
          }
        });
  }
}
