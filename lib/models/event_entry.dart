class EventEntry {
  final String entryID;
  final String userID;
  final String eventID;
  final String raceClass;
  final int raceNumber;
  final String vehicle;
  final DateTime eventDate;
  final DateTime entryDate;

  EventEntry({
    required this.entryID,
    required this.userID,
    required this.eventID,
    required this.raceClass,
    required this.raceNumber,
    required this.vehicle,
    required this.eventDate,
    required this.entryDate,
  });
}
