import 'package:flutter/material.dart';

import '../widgets/appbar_profile.dart';
import '../widgets/event_data_table.dart';
import '../screens/entry_screen.dart';
import '../models/event.dart';

class EventScreen extends StatefulWidget {
  final Event _event;

  const EventScreen(this._event, {Key? key}) : super(key: key);

  @override
  State<EventScreen> createState() => _EventScreenState();
}

class _EventScreenState extends State<EventScreen> {
  String _dropDownValue = '';
  bool _isSet = false;

  @override
  Widget build(BuildContext context) {
    Event _thisEvent = widget._event;
    if (!_isSet) {
      _dropDownValue = _thisEvent.classes.first;
      _isSet = true;
    }
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            _thisEvent.location +
                ", ${_thisEvent.date.day}.${_thisEvent.date.month}.${_thisEvent.date.year}.",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        actions: const [
          AppBarProfile(),
        ],
      ),
      body: Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 200,
            child: Hero(
              tag: _thisEvent.id,
              child: Image.network(
                _thisEvent.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          _thisEvent.isFinished
              ? const SizedBox.shrink()
              : ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => EntryScreen(
                            _thisEvent.id, _thisEvent.classes, _thisEvent.date),
                      ),
                    );
                  },
                  child: const Text(
                    'Prijava',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(300, 50),
                    elevation: 5,
                  ),
                ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Odaberite klasu: ',
                  textAlign: TextAlign.start,
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: Theme.of(context).primaryColor),
                ),
                SizedBox(
                  width: 200,
                  child: DropdownButton<String>(
                    dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                    menuMaxHeight: 320,
                    isExpanded: true,
                    underline: Container(
                      height: 2,
                      color: Colors.orange,
                    ),
                    value: _dropDownValue,
                    items: _thisEvent.classes
                        .map<DropdownMenuItem<String>>((String e) {
                      return DropdownMenuItem<String>(
                        value: e,
                        child: Text(
                          e,
                          style: const TextStyle(color: Colors.white),
                        ),
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
          ),
          const SizedBox(
            height: 10,
          ),
          EventDataTable(
            _thisEvent.id,
            _dropDownValue,
            _thisEvent.isFinished,
          ),
        ],
      ),
    );
  }
}
