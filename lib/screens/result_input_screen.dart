import 'package:flutter/material.dart';

import '../models/event_entry.dart';
import '../models/user.dart';
import '../data_providers/user_data.dart';
import '../data_providers/entry_data.dart';
import '../data_providers/result_data.dart';

class ResultInputScreen extends StatefulWidget {
  final String _eventID;
  final DateTime _eventDate;
  final List<String> _eventClasses;

  const ResultInputScreen(this._eventID, this._eventDate, this._eventClasses,
      {Key? key})
      : super(key: key);

  @override
  _ResultInputScreenState createState() => _ResultInputScreenState();
}

class _ResultInputScreenState extends State<ResultInputScreen> {
  final _formKey = GlobalKey<FormState>();
  String _classesValue = '';
  bool _isThereEntry = false;
  String _userID = '';
  int _racePosition = 0;
  int _racePoints = 0;

  @override
  void initState() {
    super.initState();
    _classesValue = widget._eventClasses.first;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Unos rezultata',
            style: TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Container(
            padding: const EdgeInsets.all(16),
            width: double.infinity,
            child: Form(
              key: _formKey,
              child: SizedBox(
                child: Column(
                  children: [
                    DropdownButtonFormField(
                        dropdownColor:
                            Theme.of(context).scaffoldBackgroundColor,
                        value: widget._eventClasses.first,
                        items: widget._eventClasses
                            .map<DropdownMenuItem<String>>((String item) {
                          return DropdownMenuItem<String>(
                            value: item,
                            child: Text(
                              item,
                              style: const TextStyle(
                                color: Colors.white,
                              ),
                            ),
                          );
                        }).toList(),
                        onChanged: (String? newValue) {
                          setState(() {
                            _classesValue = newValue!;
                          });
                        }),
                    const SizedBox(
                      height: 25,
                    ),
                    FutureBuilder<List<EventEntry>>(
                        future: getEventEntries(widget._eventID, _classesValue),
                        builder: (context, snapshot) {
                          if (snapshot.hasData && snapshot.data!.isNotEmpty) {
                            Future.delayed(Duration.zero, () async {
                              setState(() {
                                _isThereEntry = true;
                              });
                            });
                            EventEntry _entryValue = snapshot.data!.first;
                            return DropdownButtonFormField(
                                value: _entryValue,
                                items: snapshot.data!
                                    .map<DropdownMenuItem<EventEntry>>(
                                        (EventEntry item) {
                                  return DropdownMenuItem<EventEntry>(
                                    value: item,
                                    child: FutureBuilder<AppUser>(
                                        future: readUserData(item.userID),
                                        builder: (context, snapshot) {
                                          if (snapshot.hasData) {
                                            _userID = item.userID;
                                            return Text(snapshot.data!.name +
                                                ' ' +
                                                snapshot.data!.surname);
                                          } else if (snapshot.hasError) {
                                            return const Text('Greška');
                                          } else {
                                            return const Center(
                                              child:
                                                  CircularProgressIndicator(),
                                            );
                                          }
                                        }),
                                  );
                                }).toList(),
                                onChanged: (EventEntry? newValue) {
                                  setState(() {
                                    _entryValue = newValue!;
                                  });
                                });
                          } else {
                            Future.delayed(Duration.zero, () async {
                              setState(() {
                                _isThereEntry = false;
                              });
                            });

                            return const Text(
                              'Nije bilo prijava u toj klasi',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                              ),
                            );
                          }
                        }),
                    const SizedBox(
                      height: 25,
                    ),
                    Visibility(
                      visible: _isThereEntry,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null) {
                            return 'Unesite broj';
                          } else if (int.parse(value) < 0 &&
                              int.parse(value) > 100) {
                            return 'Broj mora biti veći od 0 i manji od 100';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.end,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Unesite završnu poziciju',
                          labelStyle: TextStyle(
                            color: Colors.white,
                          ),
                        ),
                        onSaved: (newValue) {
                          _racePosition = int.tryParse(newValue!)!;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 25,
                    ),
                    Visibility(
                      visible: _isThereEntry,
                      maintainSize: true,
                      maintainAnimation: true,
                      maintainState: true,
                      child: TextFormField(
                        style: const TextStyle(color: Colors.white),
                        validator: (value) {
                          if (value == null) {
                            return 'Unesite broj';
                          } else if (int.parse(value) < 0 &&
                              int.parse(value) > 1000) {
                            return 'Broj mora biti veći od 0 i manji od 1000';
                          }
                          return null;
                        },
                        keyboardType: TextInputType.number,
                        textAlign: TextAlign.end,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Unesite dobivene bodove',
                          labelStyle: TextStyle(color: Colors.white),
                        ),
                        onSaved: (newValue) {
                          _racePoints = int.tryParse(newValue!)!;
                        },
                      ),
                    ),
                    const SizedBox(
                      height: 50,
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        fixedSize: const Size(250, 50),
                        elevation: 5,
                      ),
                      onPressed: () {
                        bool _isValid = _formKey.currentState!.validate();
                        if (_isValid) {
                          _formKey.currentState!.save();
                          addNewResult(
                            _userID,
                            widget._eventID,
                            widget._eventDate,
                            _racePosition,
                            _racePoints,
                            _classesValue,
                          );
                        }
                      },
                      child: const Text(
                        'Unesi',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 16,
                    ),
                    TextButton(
                      child: const Text('Odustani'),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
