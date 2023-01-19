import 'package:self_task_student/Data/Database/SQLite/Model/AssignmentModel.dart';

import '../Repository/UserCourseRepository.dart';

class AssignmentProvider{
  final _AssignmentInstance = CourseDatabase.instance;

  Future<List<AssignmentModel>> getAssignmentData(String userId, int courseId) {
    return _AssignmentInstance.getUserAssignment(userId, courseId);
  }

  Future<List<AssignmentModel>> getAssignmentDateData(String userId, String date){
    return _AssignmentInstance.getUserAssignmentDate(userId, date);
  }

  Future<List<AssignmentModel>> getAssignmentDateWithoutDate(String userId){
    return _AssignmentInstance.getUserAssignmentDateWithoutDate(userId);
  }

  Future<AssignmentModel> getSpecificAssignmentData(int id){
    return _AssignmentInstance.getSpecificAssignment(id);
  }

  Future<int> addAssignmentData(AssignmentModel assignmentModel){
    return _AssignmentInstance.addAssignment(assignmentModel);
  }

  Future<int> updateAssignmentData(AssignmentModel assignmentModel){
    return _AssignmentInstance.updateAssignment(assignmentModel);
  }

  Future<int> updateIsCompleteData(int assignmentID, int newIsComplete){
    print("assignmentID: $assignmentID isComplete: $newIsComplete");
    return _AssignmentInstance.updateIsComlete(assignmentID, newIsComplete);
  }

  Future<int> deleteAssignmentData(int id){
    return _AssignmentInstance.deleteAssignment(id);
  }
}