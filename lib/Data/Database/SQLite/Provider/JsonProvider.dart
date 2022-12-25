import 'package:self_task_student/Data/Database/SQLite/Model/CourseListModel.dart';
import 'package:self_task_student/Data/Database/SQLite/Repository/JsonCourseRepository.dart';

class JsonPovider{
  final _provider = JsonCourseRepository();

  Future<List<CourseListModel>> fetchCourseJson() {
    return _provider.fetchCourseList();
  }
}