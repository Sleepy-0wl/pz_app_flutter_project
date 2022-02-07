// Model for event results.

class EventResult {
  String resultID;
  String userID;
  String eventID;
  DateTime eventDate;
  int racePosition;
  int racePoints;
  String raceClass;

  EventResult({
    required this.resultID,
    required this.userID,
    required this.eventID,
    required this.eventDate,
    required this.racePosition,
    required this.racePoints,
    required this.raceClass,
  });
}
