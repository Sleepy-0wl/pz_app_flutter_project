import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

import './screens/main_screen.dart';
import './screens/auth_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const PrvenstvoZagorja());
}

class PrvenstvoZagorja extends StatelessWidget {
  const PrvenstvoZagorja({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Prvenstvo Zagorja',
      theme: ThemeData(
        fontFamily: 'Roboto',
        primarySwatch: Colors.orange,
        cardColor: const Color.fromRGBO(225, 225, 225, 1),
        scaffoldBackgroundColor: const Color.fromRGBO(45, 45, 45, 1),
      ),
      // StreamBuilder which listens to changes in authentication.
      // If user is authenticated builder returns apps main screen and if not, builder returns authentication screen.
      // In case of an error, it returns text widget saying there's some error.
      home: StreamBuilder(
        stream: FirebaseAuth.instance.authStateChanges(),
        builder: (ctx, snapshot) {
          if (snapshot.hasData) {
            return const MainScreen();
          } else if (snapshot.hasError) {
            return const Center(
              child: Text('Došlo je do greške, pokušajte ponovno kasnije'),
            );
          } else {
            return const AuthScreen();
          }
        },
      ),
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
    );
  }
}
