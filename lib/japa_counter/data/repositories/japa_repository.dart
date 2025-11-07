import 'package:ibs_platform/japa_counter/data/models/japa_count.dart';

class JapaRepository {
  Future<JapaCount> getJapaCount() async {
    // In a real app, you would fetch this from a database or local storage
    return JapaCount(count: 108);
  }
}

