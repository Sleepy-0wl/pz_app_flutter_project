import 'package:flutter/material.dart';

import '../screens/event_screen.dart';
import '../models/event.dart';

class MainScreenCard extends StatelessWidget {
  final Event _event;

  const MainScreenCard(this._event, {Key? key}) : super(key: key);

  String _classesIntoString(List<String> classes) {
    String result = '';
    for (var element in classes) {
      result = result + element + ', ';
    }
    result = result.substring(0, result.length - 2);
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => EventScreen(_event),
          ),
        );
      },
      child: SizedBox(
        height: 290,
        width: 320,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            children: [
              Stack(
                children: [
                  SizedBox(
                    height: 125,
                    width: double.infinity,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Hero(
                        tag: _event.id,
                        child: Image.network(
                          _event.imageUrl,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    left: 0,
                    child: ClipRRect(
                      borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      child: Container(
                        color: Colors.black54,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            vertical: 2,
                            horizontal: 10,
                          ),
                          child: Text(
                            _event.location,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(4.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          size: 18,
                          color: Colors.black,
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 2, left: 4),
                          child: Text(
                            "${_event.date.day}.${_event.date.month}.${_event.date.year}.",
                            style: const TextStyle(
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                    child: SizedBox(
                      width: double.infinity,
                      height: 110,
                      child: Text(
                        _classesIntoString(_event.classes),
                        overflow: TextOverflow.fade,
                        maxLines: 7,
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
