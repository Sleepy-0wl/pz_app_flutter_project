import 'package:flutter/material.dart';

import '../data_providers/entry_data.dart';
import '../data_providers/user_data.dart';
import '../data_providers/result_data.dart';
import '../models/user.dart';
import '../models/event_entry.dart';
import '../models/event_result.dart';
import '../screens/user_profile_screen.dart';

class EventDataTable extends StatelessWidget {
  final String _eventID;
  final String _raceClass;
  final bool _isFinished;

  const EventDataTable(this._eventID, this._raceClass, this._isFinished,
      {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<EventEntry> entries = [];
    List<EventResult> results = [];
    return FutureBuilder<List<Object>>(
        future: _isFinished
            ? getEventResult(_eventID, _raceClass)
            : getEventEntries(_eventID, _raceClass),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            _isFinished
                ? results = snapshot.data! as List<EventResult>
                : entries = snapshot.data! as List<EventEntry>;
            return entries.isEmpty && results.isEmpty
                ? Center(
                    child: Text(
                      _isFinished
                          ? 'Nema rezultata za odabranu klasu'
                          : 'Nema prijava za odabranu klasu',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                      ),
                    ),
                  )
                : DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          _isFinished ? 'Poredak' : 'St. broj',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      const DataColumn(
                        label: Text(
                          'Natjecatelj',
                          style: TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          _isFinished ? 'Bodovi' : 'Vozilo',
                          style: const TextStyle(
                            color: Colors.orange,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                    rows: List<DataRow>.generate(
                      _isFinished ? results.length : entries.length,
                      (index) => DataRow(
                        cells: <DataCell>[
                          DataCell(
                            Text(
                              _isFinished
                                  ? results[index].racePosition.toString() + '.'
                                  : entries[index].raceNumber.toString(),
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                          DataCell(
                            FutureBuilder<AppUser>(
                                future: readUserData(_isFinished
                                    ? results[index].userID
                                    : entries[index].userID),
                                builder: (context, snapshot) {
                                  if (snapshot.hasData) {
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) =>
                                                UserProfileScreen(_isFinished
                                                    ? results[index].userID
                                                    : entries[index].userID),
                                          ),
                                        );
                                      },
                                      child: Text(
                                        snapshot.data!.name +
                                            ' ' +
                                            snapshot.data!.surname,
                                        style: const TextStyle(
                                          color: Colors.white,
                                        ),
                                      ),
                                    );
                                  } else {
                                    return const Text(
                                      'Greška',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 16,
                                      ),
                                    );
                                  }
                                }),
                          ),
                          DataCell(
                            Text(
                              _isFinished
                                  ? results[index].racePoints.toString()
                                  : entries[index].vehicle,
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                    columnSpacing: 60,
                    border: TableBorder.all(
                        width: 1,
                        color: Colors.orange,
                        style: BorderStyle.solid),
                  );
          } else {
            return const Center(
              child: Text(
                'Nema podataka za ovu klasu',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                ),
              ),
            );
          }
        });
  }
}
