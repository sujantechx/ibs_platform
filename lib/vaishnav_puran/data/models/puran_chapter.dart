// filepath: c:\FlutterDev\ibs_platform\lib\vaishnav_puran\data\models\puran_chapter.dart
class PuranChapter {
  final String id;
  final String title;
  final String? content;
  final int? order;

  PuranChapter({required this.id, required this.title, this.content, this.order});

  factory PuranChapter.fromMap(Map<String, dynamic> map, String id) {
    return PuranChapter(
      id: id,
      title: map['title']?.toString() ?? '',
      content: map['content']?.toString(),
      order: map['order'] is int ? map['order'] as int : (map['order'] != null ? int.tryParse(map['order'].toString()) : null),
    );
  }
}
