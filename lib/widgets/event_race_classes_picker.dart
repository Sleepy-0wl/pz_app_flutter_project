import 'package:flutter/material.dart';

import '../race_classes.dart';

// This widget allows user to pick race classes for the new event. Accessed in new_event_screen.dart.
// It's a ListView with checkboxes as visual confirmation of chosen race class.
class EventRaceClassesPicker extends StatefulWidget {
  const EventRaceClassesPicker({Key? key}) : super(key: key);

  @override
  _EventRaceClassesPickerState createState() => _EventRaceClassesPickerState();
}

Map<String, bool> _classesMap = {
  for (var element in RaceClasses.sveKlase) element: false
};

List<String> getClasses() {
  List<String> pickedClasses = [];
  for (var element in _classesMap.keys) {
    if (_classesMap[element] == true) {
      pickedClasses.add(element);
    }
  }
  return pickedClasses;
}

class _EventRaceClassesPickerState extends State<EventRaceClassesPicker> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: _classesMap.length,
      itemBuilder: (context, index) {
        return CheckboxListTile(
          title: Text(
            _classesMap.keys.elementAt(index),
            style: const TextStyle(color: Colors.white),
          ),
          value: _classesMap.values.elementAt(index),
          onChanged: (bool? newValue) {
            setState(() {
              _classesMap.update(
                  _classesMap.keys.elementAt(index), (value) => newValue!);
            });
          },
        );
      },
    );
  }
}
