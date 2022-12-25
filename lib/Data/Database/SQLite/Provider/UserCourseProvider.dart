import 'package:firebase_auth/firebase_auth.dart';
import 'package:self_task_student/Data/Database/SQLite/Model/UserCourseModel.dart';

import '../Repository/UserCourseRepository.dart';

class UserCourseProvider {
  final _userCourseInstance = CourseDatabase.instance;

  Future<List<UserCourseModel>> getAllCourseData(String userId) {
    return _userCourseInstance.getAllCourseData(userId);
  }

  // Future<UserCourseModel> getAllUserCourseData(String userId) {
  //   return _userCourseInstance.getAllUserCourseData(userId);
  // }

  Future<UserCourseModel> getSpecificUserCourseData(int id) {
    return _userCourseInstance.getSpecificUserCourseData(id);
  }

  Future<int> saveCourseData(UserCourseModel userCourseModel) {
    return _userCourseInstance.addCourse(userCourseModel);
  }

  Future<int> updateData(UserCourseModel userCourseModel) {
    return _userCourseInstance.update(userCourseModel);
  }

  Future<int> deleteData(int id) {
    return _userCourseInstance.delete(id);
  }

  Future<int> updatePercentage(int courseId){
    return _userCourseInstance.percentageCalc(courseId);
  }
}
