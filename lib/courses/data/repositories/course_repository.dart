import 'package:ibs_platform/courses/data/models/course.dart';

class CourseRepository {
  Future<List<Course>> getCourses() async {
    // In a real app, you would fetch this from a database or API
    return [
      Course(title: 'Course 1', description: 'Description for course 1'),
      Course(title: 'Course 2', description: 'Description for course 2'),
    ];
  }
}

