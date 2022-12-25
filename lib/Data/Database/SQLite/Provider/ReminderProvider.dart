import 'package:self_task_student/Data/Database/SQLite/Model/ReminderModel.dart';
import 'package:self_task_student/Data/Database/SQLite/Repository/UserCourseRepository.dart';

class ReminderProvider {
  final _reminderInstance = CourseDatabase.instance;

  Future<int> createReminder(ReminderModel reminderModel) {
    return _reminderInstance.addReminder(reminderModel);
  }

  Future<int> updateReminder(ReminderModel reminderModel) {
    return _reminderInstance.updateReminder(reminderModel);
  }

  Future<int> deleteReminder(int id) {
    return _reminderInstance.deleteReminder(id);
  }

  Future<List<ReminderModel>> getAllReminderWithDate(
      String userId, String date) {
    return _reminderInstance.getAllReminderData(userId, date);
  }

  Future<List<ReminderModel>> getAllReminderWithoutDate(
      String userId) {
    return _reminderInstance.getAllReminderDataWithoutDate(userId);
  }

  Future<ReminderModel> getSpecificReminder(int id) {
    return _reminderInstance.getSpecificUserRemindereData(id);
  }
}
