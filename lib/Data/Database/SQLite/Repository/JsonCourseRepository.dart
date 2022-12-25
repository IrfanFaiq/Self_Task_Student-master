import 'dart:convert';

import 'package:self_task_student/Data/Database/SQLite/Model/CourseListModel.dart';
import 'package:http/http.dart' as http;

class JsonCourseRepository{
  Future <List<CourseListModel>> fetchCourseList() async {
    final response =
    await http
        .get(
    Uri.parse('https://json-selftask.herokuapp.com/course'));
    if (response.statusCode == 200) {
      List jsonResponse = json.decode(response.body);
      return jsonResponse.map((data) => CourseListModel.fromJson(data)).toList();
    } else {
      throw Exception('Unexpected error occured!');
    }
  }


}