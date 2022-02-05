class AppUser {
  final String id;
  final String email;
  final String name;
  final String surname;
  final DateTime dateOfBirth;
  final String country;
  final bool isAdmin;
  String? imageUrl;

  AppUser({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    required this.dateOfBirth,
    required this.country,
    this.isAdmin = false,
    this.imageUrl,
  });
}
