import 'package:flutter/material.dart';
import 'package:pz_app/data_providers/user_data.dart';

class LogIn extends StatefulWidget {
  const LogIn({Key? key}) : super(key: key);

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  String _email = '';
  String _password = '';

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
                TextFormField(
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
                  onSaved: (value) {
                    _email = value as String;
                  },
                ),
                TextFormField(
                  style: const TextStyle(color: Colors.white),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Unesite lozinku';
                    }
                    return null;
                  },
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Lozinka',
                    labelStyle: TextStyle(color: Colors.white),
                  ),
                  onSaved: (value) {
                    _password = value as String;
                  },
                ),
              ],
            ),
          ),
        ),
        ElevatedButton(
          onPressed: () {
            FocusScope.of(context).unfocus();

            bool _isValid = _formKey.currentState!.validate();
            if (_isValid) {
              _formKey.currentState!.save();
              logUserIn(_email, _password);
            }
          },
          child: const Text(
            'Prijava',
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
