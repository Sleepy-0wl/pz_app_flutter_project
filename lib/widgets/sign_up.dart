import 'dart:io';

import 'package:flutter/material.dart';

import '../widgets/user_image_picker.dart';
import '../data_providers/user_data.dart';

class SignUp extends StatefulWidget {
  const SignUp({Key? key}) : super(key: key);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final _formKey = GlobalKey<FormState>();
  List<String> countries = ['HR', 'SLO'];
  var _userImageFile;
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _surname = TextEditingController();
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
                  controller: _email,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value!.isEmpty || !value.contains('@')) {
                      return 'Unesite valjanu email adresu';
                    }
                    return null;
                  },
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email adresa',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ), //email
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  controller: _password,
                  validator: (value) {
                    if (value!.isEmpty && value.length > 5) {
                      return 'Unesite lozinku od barem 6 znakova';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Lozinka',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ), //password
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value != _password.text) {
                      return 'Lozinke se ne podudaraju';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Potvrdite lozinku',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  obscureText: true,
                ), //confirm
                TextFormField(
                  controller: _name,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Unesite ime';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Ime',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ), //name
                TextFormField(
                  controller: _surname,
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Unesite prezime';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Prezime',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                ), //surname
                Padding(
                  padding: const EdgeInsets.only(top: 4),
                  child: Row(
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
                          'Odaberi datum rođenja',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.black,
                          ),
                        ),
                      ),
                      Text(
                        "${_selectedDate.day}.${_selectedDate.month}.${_selectedDate.year}.",
                        style: const TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
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
                  hint: const Text('Država',
                      style: TextStyle(color: Colors.white)),
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
              addNewUser(
                _email.text,
                _password.text,
                _name.text,
                _surname.text,
                _selectedDate,
                _country,
                _userImageFile,
              );
            }
          },
          child: const Text(
            'Registracija',
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
