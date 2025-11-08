class Puran {
  final String id;
  final String title;
  final String? description;

  Puran({required this.id, required this.title, this.description});

  factory Puran.fromMap(Map<String, dynamic> map, String id) {
    return Puran(
      id: id,
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString(),
    );
  }
}
