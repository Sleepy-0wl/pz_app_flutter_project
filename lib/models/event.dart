class Event {
  final String id;
  final DateTime date;
  final String location;
  final String imageUrl;
  final List<String> classes;
  final bool isFinished;

  Event({
    required this.id,
    required this.date,
    required this.location,
    required this.imageUrl,
    required this.classes,
    required this.isFinished,
  });
}
