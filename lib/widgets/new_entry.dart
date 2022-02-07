import 'package:flutter/material.dart';

import '../data_providers/entry_data.dart';

// Widget for making new entry for a specific event and a chosen race class.
// Accessed in entry_screen.dart.
class NewEntry extends StatefulWidget {
  final String _eventID;
  final List<String> _raceClasses;
  final DateTime _eventDate;

  const NewEntry(this._eventID, this._raceClasses, this._eventDate, {Key? key})
      : super(key: key);

  @override
  _NewEntryState createState() => _NewEntryState();
}

class _NewEntryState extends State<NewEntry> {
  final _formKey = GlobalKey<FormState>();
  String _dropDownValue = '';
  bool _dropDownSet = false;
  int _raceNumber = 0;
  String _vehicle = '';

  @override
  Widget build(BuildContext context) {
    if (!_dropDownSet) {
      _dropDownValue = widget._raceClasses.first;
      _dropDownSet = true;
    }
    return Column(
      children: [
        const SizedBox(
          height: 100,
        ),
        Form(
          key: _formKey,
          child: Column(
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Odaberite klasu:'),
                  SizedBox(
                    width: 250,
                    child: DropdownButtonFormField<String>(
                      isExpanded: true,
                      menuMaxHeight: 320,
                      value: _dropDownValue,
                      items: widget._raceClasses
                          .map<DropdownMenuItem<String>>((String e) {
                        return DropdownMenuItem<String>(
                          value: e,
                          child: Text(e),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setState(() {
                          _dropDownValue = newValue!;
                        });
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null) {
                    return 'Unesite broj';
                  } else if (int.parse(value) < 0 && int.parse(value) > 1000) {
                    return 'Broj mora biti veći od 0 i manji od 1000';
                  }
                  return null;
                },
                keyboardType: TextInputType.number,
                textAlign: TextAlign.end,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Unesite željeni startni broj',
                ),
                onSaved: (newValue) {
                  _raceNumber = int.tryParse(newValue!)!;
                },
              ),
              const SizedBox(
                height: 30,
              ),
              TextFormField(
                validator: (value) {
                  if (value == null || value.length < 3) {
                    return 'Unesite valjanu vrijednost vozila';
                  }
                  return null;
                },
                textAlign: TextAlign.end,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Unesite vaše vozilo',
                ),
                onSaved: (String? newValue) {
                  _vehicle = newValue as String;
                },
              ),
              const SizedBox(
                height: 100,
              ),
            ],
          ),
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
              addNewEntry(widget._eventID, _dropDownValue, _raceNumber,
                      _vehicle, widget._eventDate)
                  .catchError((error) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    backgroundColor: Colors.grey,
                    content: SizedBox(
                      height: 20,
                      child: Center(
                        child: Text(
                          'Prijava nije uspjela!',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              });
            }
            Navigator.pop(context);
          },
          child: const Text(
            'Prijavi me',
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
    );
  }
}
