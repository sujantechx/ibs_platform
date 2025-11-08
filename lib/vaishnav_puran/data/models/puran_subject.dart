// filepath: c:\FlutterDev\ibs_platform\lib\vaishnav_puran\data\models\puran_subject.dart
class PuranSubject {
  final String id;
  final String title;
  final String? description;
  final int? order;

  PuranSubject({required this.id, required this.title, this.description, this.order});

  factory PuranSubject.fromMap(Map<String, dynamic> map, String id) {
    return PuranSubject(
      id: id,
      title: map['title']?.toString() ?? '',
      description: map['description']?.toString(),
      order: map['order'] is int ? map['order'] as int : (map['order'] != null ? int.tryParse(map['order'].toString()) : null),
    );
  }
}
