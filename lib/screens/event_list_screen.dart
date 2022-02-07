import 'package:flutter/material.dart';

import '../widgets/appbar_profile.dart';
import '../screens/event_screen.dart';
import '../screens/result_input_screen.dart';
import '../models/event.dart';
import '../data_providers/event_data.dart';

// This screen displays list of events. Called from app_drawer.dart.
// Receives two bool arguments. _finished for adjusting UI and data from Firebase according to information is event finished or not.
// _isAdmin shows if current user is admin and accordingly UI adjusts.
class EventListScreen extends StatelessWidget {
  final bool _finished;
  final bool _isAdmin;

  const EventListScreen(this._finished, this._isAdmin, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          _finished ? 'Završeni eventovi' : 'Nadolazeći eventovi',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: const [
          AppBarProfile(),
        ],
      ),
      body: FutureBuilder<List<Event>>(
          future: getEvents(_finished),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              List<Event> events = snapshot.data!;
              return SizedBox(
                width: double.infinity,
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8),
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20)),
                        height: 100,
                        child: Stack(
                          children: [
                            SizedBox(
                              height: 100,
                              width: double.infinity,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(20),
                                child: Image.network(
                                  events[index].imageUrl,
                                  fit: BoxFit.cover,
                                ),
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                color: Colors.black26,
                              ),
                            ),
                            ListTile(
                              title: Padding(
                                padding: const EdgeInsets.only(top: 70),
                                child: Text(
                                  events[index].location +
                                      ', ' +
                                      "${events[index].date.day}.${events[index].date.month}.${events[index].date.year}.",
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              trailing: _finished && _isAdmin
                                  ? IconButton(
                                      color: Colors.orange,
                                      iconSize: 48,
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                ResultInputScreen(
                                                    events[index].id,
                                                    events[index].date,
                                                    events[index].classes),
                                          ),
                                        );
                                      },
                                      icon: const Icon(
                                          Icons.admin_panel_settings))
                                  : const SizedBox.shrink(),
                              onTap: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EventScreen(events[index]),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            } else if (snapshot.hasError) {
              return const Center(
                child: Text('Došlo je do pogreške'),
              );
            } else {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
          }),
    );
  }
}
