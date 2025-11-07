import 'package:ibs_platform/vaishnav_puran/data/models/puran.dart';

class PuranRepository {
  Future<List<Puran>> getPurans() async {
    // In a real app, you would fetch this from a database or API
    return [
      Puran(title: 'Puran 1', content: 'Content for puran 1'),
      Puran(title: 'Puran 2', content: 'Content for puran 2'),
    ];
  }
}

