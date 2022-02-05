import 'dart:io';

import 'package:flutter/material.dart';

import '../widgets/user_image_picker.dart';
import '../data_providers/user_data.dart';
import '../models/user.dart';

class UpdateUser extends StatefulWidget {
  final AppUser _user;

  const UpdateUser(this._user, {Key? key}) : super(key: key);

  @override
  _UpdateUserState createState() => _UpdateUserState();
}

class _UpdateUserState extends State<UpdateUser> {
  final _formKey = GlobalKey<FormState>();
  List<String> countries = ['HR', 'SLO'];
  var _userImageFile;
  String _name = '';
  String _surname = '';
  String _country = '';
  DateTime _selectedDate = DateTime.now();

  void _selectDate(BuildContext context) async {
    final DateTime? selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1940),
      lastDate: DateTime(2025),
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
  void initState() {
    super.initState();
    var user = widget._user;
    _name = user.name;
    _surname = user.surname;
    _selectedDate = user.dateOfBirth;
    _country = user.country;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                UserImagePicker(_pickedImage), //image
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Unesite ime';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Ime',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  onSaved: (value) {
                    _name = value as String;
                  },
                  initialValue: _name,
                ), //name
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Unesite prezime';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Prezime',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  onSaved: (value) {
                    _surname = value as String;
                  },
                  initialValue: _surname,
                ), //surname
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                        top: 4,
                      ),
                      child: TextButton.icon(
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
                          'Odaberi datum rođenja',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      "${_selectedDate.day}/${_selectedDate.month}/${_selectedDate.year}",
                      style: const TextStyle(color: Colors.white),
                    ),
                  ],
                ),
                DropdownButtonFormField(
                  dropdownColor: Theme.of(context).scaffoldBackgroundColor,
                  validator: (value) {
                    if (value == null) {
                      return 'Odaberite državu';
                    }
                    return null;
                  },
                  items: countries.map<DropdownMenuItem<String>>((String e) {
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
                      _country = newValue!;
                    });
                  },
                  hint: const Text(
                    'Država',
                    style: TextStyle(color: Colors.white),
                  ),
                )
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            bool _isValid = _formKey.currentState!.validate();
            if (_isValid) {
              _formKey.currentState!.save();
              updateUserData(
                widget._user.id,
                _name,
                _surname,
                _selectedDate,
                _country,
                _userImageFile,
              );
            }
            Navigator.of(context).pop();
            Navigator.of(context).pop();
          },
          child: const Text(
            'Promijeni',
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
      ],
    );
  }
}
