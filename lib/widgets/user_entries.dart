import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../models/event_entry.dart';
import '../models/event_result.dart';
import '../data_providers/entry_data.dart';
import '../data_providers/result_data.dart';

// Widget that displays entries and results of given user. Accessed in user_profile_screen.dart.
class UserEntries extends StatefulWidget {
  final String _userID;

  const UserEntries(this._userID, {Key? key}) : super(key: key);
  @override
  _UserEntriesState createState() => _UserEntriesState();
}

class HeaderItems {
  final String headerText;
  bool isExpanded;

  HeaderItems({
    required this.headerText,
    this.isExpanded = false,
  });
}

class _UserEntriesState extends State<UserEntries> {
  final List<HeaderItems> headers = [
    HeaderItems(headerText: 'Prijave'),
    HeaderItems(headerText: 'Rezultati'),
  ];
  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      children: [
        ExpansionPanelList(
          expansionCallback: (int index, bool isExpanded) {
            setState(() {
              headers[index].isExpanded = !headers[index].isExpanded;
            });
          },
          children: headers.map((HeaderItems item) {
            return ExpansionPanel(
              backgroundColor: Theme.of(context).cardColor,
              headerBuilder: (BuildContext context, bool isExpanded) {
                return Padding(
                  padding: const EdgeInsets.only(
                    top: 24,
                    left: 8,
                  ),
                  child: Text(
                    item.headerText,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                );
              },
              isExpanded: item.isExpanded,
              body: item.headerText.contains('Prijave')
                  ? FutureBuilder<List<EventEntry>>(
                      future: getUserEntries(widget._userID),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<EventEntry> entries = snapshot.data!;
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: entries.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  tileColor: index.isEven
                                      ? Colors.orange[200]
                                      : Colors.white,
                                  title: Text(
                                      "${entries[index].eventDate.day}.${entries[index].eventDate.month}.${entries[index].eventDate.year}.    " +
                                          entries[index].raceClass),
                                  trailing: DateTime.now().isBefore(
                                              entries[index].eventDate) &&
                                          entries[index].userID ==
                                              FirebaseAuth
                                                  .instance.currentUser!.uid
                                      ? IconButton(
                                          icon: const Icon(Icons.delete),
                                          onPressed: () {
                                            deleteEntry(entries[index].entryID);
                                            setState(() {});
                                          },
                                        )
                                      : const SizedBox.shrink(),
                                );
                              });
                        } else {
                          return const Center(
                            child: Text('Došlo je do greške'),
                          );
                        }
                      })
                  : FutureBuilder<List<EventResult>>(
                      future: getUserResults(widget._userID),
                      builder: (context, snapshot) {
                        if (snapshot.hasData) {
                          List<EventResult> results = snapshot.data!;
                          return ListView.builder(
                              shrinkWrap: true,
                              itemCount: results.length,
                              itemBuilder: (context, index) {
                                return ListTile(
                                  title: Text(results[index].raceClass),
                                  leading: Text(
                                    results[index].racePoints.toString(),
                                  ),
                                  trailing: Text(
                                      results[index].racePosition.toString() +
                                          '.'),
                                );
                              });
                        } else {
                          return const Center(
                            child: Text('Došlo je do greške'),
                          );
                        }
                      }),
            );
          }).toList(),
        ),
      ],
    );
  }
}
