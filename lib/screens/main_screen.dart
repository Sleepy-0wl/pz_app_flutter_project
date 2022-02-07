import 'package:flutter/material.dart';

import '../widgets/main_screen_card.dart';
import '../widgets/appbar_profile.dart';
import '../widgets/app_drawer.dart';
import '../models/event.dart';
import '../data_providers/event_data.dart';

// Main screen that is shown after successful authentication. Contains two custom card widgets(main_screen_card.dart).
// First card contains data about upcoming event, second card contains data about most recently finished event.
// Pressing on the card opens event_screen.dart of that event.
class MainScreen extends StatelessWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Center(
          child: Text(
            'Prvenstvo Zagorja',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: const [
          AppBarProfile(),
        ],
      ),
      drawer: const AppDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(
                width: double.infinity,
              ),
              const Text(
                'Sljedeći event:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              FutureBuilder<Event>(
                  future: getSoonestUnfinished(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return MainScreenCard(snapshot.data!);
                    } else if (snapshot.hasError) {
                      return const Text('Došlo je do pogreške');
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    }
                  }),
              const SizedBox(
                height: 8,
              ),
              const Text(
                'Rezultati prethodnog eventa:',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(
                height: 8,
              ),
              FutureBuilder<Event>(
                  future: getLatestFinished(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return MainScreenCard(snapshot.data!);
                    } else if (snapshot.hasError) {
                      return const Text('Došlo je do pogreške');
                    } else {
                      return Center(
                        child: CircularProgressIndicator(
                          color: Theme.of(context).primaryColor,
                        ),
                      );
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}
