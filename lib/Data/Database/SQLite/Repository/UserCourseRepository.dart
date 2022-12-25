import 'dart:core';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:self_task_student/Data/Database/SQLite/Model/AssignmentModel.dart';
import 'package:self_task_student/Data/Database/SQLite/Model/ReminderModel.dart';
import 'package:sqflite/sqflite.dart';

import '../Model/UserCourseModel.dart';

class CourseDatabase {
  CourseDatabase._privateContructor();

  static final CourseDatabase instance = CourseDatabase._privateContructor();

  static Database? _database;

  Future<Database> get database async => _database ??= await _initDatabase();

  Future<Database> _initDatabase() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();

    String path = join(documentsDirectory.path, 'Database.db');
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('CREATE TABLE UserCourse('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'userId TEXT NOT NULL,'
        'courseCode TEXT NOT NULL,'
        'courseName TEXT NOT NULL,'
        'creditHour TEXT NOT NULL,'
        'courseCatagory TEXT NOT NULL,'
        'courseDetail TEXT,'
        'section TEXT NOT NULL,'
        'day TEXT NOT NULL,'
        'time TEXT,'
        'labSection TEXT,'
        'labDay TEXT,'
        'labTime TEXT,'
        'completePercentage REAL NOT NULL'
        ')');
    await db.execute('CREATE TABLE Assignment('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'assignmentName TEXT NOT NULL,'
        'assignmentDesc TEXT NOT NULL,'
        'type TEXT NOT NULL,'
        'dueDate TEXT NOT NULL,'
        'dueTime TEXT NOT NULL,'
        'isComplete INT NOT NULL,'
        'userId TEXT NOT NULL,'
        'courseId INTEGER NOT NULL'
        ')');

    await db.execute('CREATE TABLE Reminder('
        'id INTEGER PRIMARY KEY AUTOINCREMENT,'
        'titleReminder TEXT NOT NULL,'
        'descriptionReminder TEXT NOT NULL,'
        'dateReminder TEXT NOT NULL,'
        'timeReminder TEXT NOT NULL,'
        'userId TEXT NOT NULL'
        ')');
  }

  Future<int> addCourse(UserCourseModel newCourseModel) async {
    Database db = await instance.database;
    return await db.insert('UserCourse', newCourseModel.toJson());
  }

  Future<List<UserCourseModel>> getAllCourseData(String userId) async {
    Database db = await instance.database;
    final userCourseData = await db.query('UserCourse',
        orderBy: 'courseCode', where: 'userId=?', whereArgs: [userId]);
    return userCourseData
        .map((json) => UserCourseModel.fromJson(json))
        .toList();
  }

  // Future<UserCourseModel> getAllUserCourseData(String userId) async {
  //   Database db = await instance.database;
  //   final userCourseData = await db.query('UserCourse',
  //       columns: [
  //         'id',
  //         'courseCode',
  //         'section',
  //         'day',
  //         'time',
  //         'labSection',
  //         'labDay',
  //         'labTime',
  //         'userId'
  //       ],
  //       where: 'userId=?',
  //       whereArgs: [userId]);
  //
  //   if (userCourseData.isNotEmpty) {
  //     return UserCourseModel.fromJson(userCourseData.first);
  //   }
  //   else{
  //     return UserCourseModel.fromJson();
  //   }
  //   throw Exception('No such ID');
  // }

  Future<UserCourseModel> getSpecificUserCourseData(int id) async {
    Database db = await instance.database;
    final userCourseData = await db.query('UserCourse',
        columns: [
          'id',
          'userId',
          'courseCode',
          'courseName',
          'creditHour',
          'courseCatagory',
          'courseDetail',
          'section',
          'day',
          'time',
          'labSection',
          'labDay',
          'labTime',
          'completePercentage'
        ],
        where: 'id=?',
        whereArgs: [id]);

    if (userCourseData.isNotEmpty) {
      return UserCourseModel.fromJson(userCourseData.first);
    }
    throw Exception('No such ID');
  }

  Future<int> update(UserCourseModel userCourseModel) async {
    Database db = await instance.database;
    print(userCourseModel.toJson());
    return db.update('UserCourse', userCourseModel.toJson(),
        where: 'id = ?', whereArgs: [userCourseModel.id]);
  }

  Future<int> delete(int id) async {
    Database db = await instance.database;
    return db.delete('UserCourse', where: 'id = ?', whereArgs: [id]);
  }

  //---------------------------------------------------------------------------//
  //-----Assignment------
  Future<List<AssignmentModel>> getUserAssignment(
      String userId, int courseId) async {
    Database db = await instance.database;
    final assignmentData = await db.query('Assignment',
        where: 'userId=? and courseId=?', whereArgs: [userId, courseId]);
    return assignmentData
        .map((json) => AssignmentModel.fromJson(json))
        .toList();
  }

  Future<List<AssignmentModel>> getUserAssignmentDate(
      String userId, String date) async {
    Database db = await instance.database;
    final assignmentData = await db.query('Assignment',
        where: 'userId=? and dueDate=?', whereArgs: [userId, date]);
    return assignmentData
        .map((json) => AssignmentModel.fromJson(json))
        .toList();
  }

  Future<List<AssignmentModel>> getUserAssignmentDateWithoutDate(
      String userId) async {
    Database db = await instance.database;
    final assignmentData = await db.query('Assignment',
        where: 'userId=?', whereArgs: [userId]);
    return assignmentData
        .map((json) => AssignmentModel.fromJson(json))
        .toList();
  }

  Future<int> addAssignment(AssignmentModel newAssignmentModel) async {
    Database db = await instance.database;
    print('hello go here please');
    return await db.insert('Assignment', newAssignmentModel.toJson());
  }

  Future<int> updateAssignment(AssignmentModel assignmentModel) async {
    Database db = await instance.database;
    return db.update('Assignment', assignmentModel.toJson(),
        where: 'id = ?', whereArgs: [assignmentModel.id]);
  }

  Future<int> updateIsComlete(int assignmentID, int newIsComplete) async {
    Database db = await instance.database;
    return db.rawUpdate(
        "UPDATE Assignment SET isComplete = $newIsComplete WHERE id = $assignmentID");
  }

  Future<AssignmentModel> getSpecificAssignment(int id) async {
    Database db = await instance.database;
    final assignmentData = await db.query('Assignment',
        columns: [
          'id',
          'assignmentName',
          'assignmentDesc',
          'type',
          'dueDate',
          'dueTime',
          'isComplete',
          'userId',
          'courseId',
        ],
        where: 'id=?',
        whereArgs: [id]);

    if (assignmentData.isNotEmpty) {
      return AssignmentModel.fromJson(assignmentData.first);
    }
    throw Exception('No such ID');
  }

  Future<int> deleteAssignment(int id) async {
    Database db = await instance.database;
    return db.delete('Assignment', where: 'id = ?', whereArgs: [id]);
  }

  //----------------------------------------------------------------------------------------------------------

  Future<int> percentageCalc(int courseID) async {
    Database db = await instance.database;
    int totalResult = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM Assignment WHERE courseId = $courseID"))!;
    int isCompleteValue = Sqflite.firstIntValue(await db.rawQuery(
        "SELECT COUNT(*) FROM Assignment WHERE courseId = $courseID AND isComplete = 1"))!;

    double percentage = isCompleteValue / totalResult;
    String percentageString = percentage.toStringAsFixed(2);
    double percentageNew = double.parse(percentageString);
    return db.rawUpdate(
        "UPDATE UserCourse SET completePercentage = $percentageNew WHERE id = $courseID");
  }

  //-----------------------------------------------------------------------------------------------------------
  Future<int> addReminder(ReminderModel reminderModel) async {
    Database db = await instance.database;
    return await db.insert('Reminder', reminderModel.toJson());
  }

  Future<List<ReminderModel>> getAllReminderData(
      String userId, String date) async {
    Database db = await instance.database;
    final reminderData = await db.query('Reminder',
        orderBy: 'timeReminder',
        where: 'userId=? AND dateReminder=?',
        whereArgs: [userId, date]);
    return reminderData.map((json) => ReminderModel.fromJson(json)).toList();
  }

  Future<List<ReminderModel>> getAllReminderDataWithoutDate(
      String userId) async {
    Database db = await instance.database;
    final reminderData = await db.query('Reminder',
        orderBy: 'timeReminder',
        where: 'userId=?',
        whereArgs: [userId]);
    return reminderData.map((json) => ReminderModel.fromJson(json)).toList();
  }

  Future<ReminderModel> getSpecificUserRemindereData(int id) async {
    Database db = await instance.database;
    final reminderData = await db.query('Reminder',
        columns: [
          'id',
          'titleReminder',
          'descriptionReminder',
          'dateReminder',
          'timeReminder',
          'userId',
        ],
        where: 'id=?',
        whereArgs: [id]);

    if (reminderData.isNotEmpty) {
      return ReminderModel.fromJson(reminderData.first);
    }
    throw Exception('No such ID');
  }

  Future<int> updateReminder(ReminderModel reminderModel) async {
    Database db = await instance.database;
    return db.update('Reminder', reminderModel.toJson(),
        where: 'id = ?', whereArgs: [reminderModel.id]);
  }

  Future<int> deleteReminder(int id) async {
    Database db = await instance.database;
    return db.delete("Reminder", where: 'id = ?', whereArgs: [id]);
  }
}
