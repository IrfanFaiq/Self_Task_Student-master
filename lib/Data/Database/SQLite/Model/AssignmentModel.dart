import 'package:equatable/equatable.dart';

class AssignmentModel extends Equatable{
  final int? id;
  final String assignmentName;
  final String? assignmentDesc;
  final String type;
  final String dueDate;
  final String dueTime;
  final String userId;
  final int courseId;
  final int isComplete;

  AssignmentModel({
    this.id,
    required this.assignmentName,
    this.assignmentDesc,
    required this.type,
    required this.dueDate,
    required this.dueTime,
    required this.userId,
    required this.courseId,
    required this.isComplete
  });

  factory AssignmentModel.fromJson(Map<String, dynamic> json) {
    return AssignmentModel(
      id: json['id'],
      assignmentName: json['assignmentName'],
      assignmentDesc: json['assignmentDesc'],
      type: json['type'],
      dueDate: json['dueDate'],
      dueTime: json['dueTime'],
      userId: json['userId'],
      courseId: json['courseId'],
      isComplete: json['isComplete']
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'assignmentName': assignmentName,
    'assignmentDesc' : assignmentDesc,
    'type' : type,
    'dueDate': dueDate,
    'dueTime': dueTime,
    'userId': userId,
    'courseId': courseId,
    'isComplete': isComplete,
  };

  @override
  List<Object?> get props => [
  id,
  assignmentName,
  assignmentDesc,
  type,
  dueDate,
  dueTime,
  userId,
  courseId,
  isComplete,
  ];

}