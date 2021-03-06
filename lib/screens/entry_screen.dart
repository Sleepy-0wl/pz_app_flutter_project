import 'package:flutter/material.dart';

import '../widgets/appbar_profile.dart';
import '../widgets/new_entry.dart';

// Screen that opens when user wants to make a new entry. Opened from event_screen.dart.

class EntryScreen extends StatefulWidget {
  final String _eventID;
  final List<String> _raceClasses;
  final DateTime _eventDate;

  const EntryScreen(this._eventID, this._raceClasses, this._eventDate,
      {Key? key})
      : super(key: key);

  @override
  _EntryScreenState createState() => _EntryScreenState();
}

class _EntryScreenState extends State<EntryScreen> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Center(
            child: Text(
              'Prijava',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: const [
            AppBarProfile(),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(8),
          child: SingleChildScrollView(
            child: NewEntry(
                widget._eventID, widget._raceClasses, widget._eventDate),
          ),
        ),
      ),
    );
  }
}
