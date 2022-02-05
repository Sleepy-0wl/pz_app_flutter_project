import 'dart:io';

import 'package:flutter/material.dart';

import '../widgets/appbar_profile.dart';
import '../widgets/event_image_picker.dart';
import '../widgets/event_race_classes_picker.dart';
import '../data_providers/event_data.dart';

class NewEventScreen extends StatefulWidget {
  const NewEventScreen({Key? key}) : super(key: key);

  @override
  _NewEventScreenState createState() => _NewEventScreenState();
}

class _NewEventScreenState extends State<NewEventScreen> {
  var _userImageFile;
  DateTime _selectedDate = DateTime.now();
  final _locationController = TextEditingController();

  void _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (selected != null && selected != _selectedDate) {
      setState(() {
        _selectedDate = selected;
      });
    }
  }

  void _pickedImage(File image) {
    _userImageFile = image;
  }

  @override
  void dispose() {
    super.dispose();
    _locationController.dispose();
  }

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
              'Novi Event',
              style: TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          actions: const [
            AppBarProfile(),
          ],
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                EventImagePicker(_pickedImage), //slika
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Lokacija',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  controller: _locationController,
                ), //lokacija
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    TextButton.icon(
                      onPressed: () {
                        FocusScope.of(context).unfocus();
                        _selectDate(context);
                      },
                      icon: const Icon(
                        Icons.calendar_today,
                        color: Colors.black,
                      ),
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all<Color>(
                            Theme.of(context).primaryColor),
                      ),
                      label: const Text(
                        'Odaberi datum eventa',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.black,
                        ),
                      ),
                    ),
                    Text(
                      "${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}.",
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ],
                ), //datum
                const SingleChildScrollView(
                  child: SizedBox(
                    height: 180,
                    child: EventRaceClassesPicker(),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    List<String> lista = getClasses();
                    try {
                      addNewEvent(_userImageFile, _locationController.text,
                          _selectedDate, lista);
                      Navigator.pop(context);
                    } catch (error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Došlo je do greške'),
                        ),
                      );
                    }
                  },
                  child: const Text(
                    'Stvori',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    fixedSize: const Size(200, 40),
                    elevation: 5,
                  ),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Odustani'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
