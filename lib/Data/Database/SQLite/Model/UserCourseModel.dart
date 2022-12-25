class UserCourseModel {
  final int? id;
  final String userId;
  final String courseCode;
  final String courseName;
  final String creditHour;
  final String courseCatagory;
  final String? courseDetail;
  final String section;
  final String day;
  final String time;
  final String? labSection;
  final String? labDay;
  final String? labTime;
  final double completePercentage;


  UserCourseModel({
    this.id,
    required this.userId,
    required this.courseCode,
    required this.courseName,
    required this.creditHour,
    required this.courseCatagory,
    this.courseDetail,
    required this.section,
    required this.day,
    required this.time,
    this.labSection,
    this.labDay,
    this.labTime,
    required this.completePercentage
  });

  factory UserCourseModel.fromJson(Map<String, dynamic> json) {
    return UserCourseModel(
      id: json['id'],
      userId: json['userId'],
      courseCode: json['courseCode'],
      courseName: json['courseName'],
      creditHour: json['creditHour'],
      courseCatagory: json['courseCatagory'],
      courseDetail: json['courseDetail'],
      section: json['section'],
      day: json['day'],
      time: json['time'],
      labSection: json['labSection'],
      labDay: json['labDay'],
      labTime: json['labTime'],
      completePercentage: json['completePercentage'],
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'userId': userId,
    'courseCode': courseCode,
    'courseName': courseName,
    'creditHour': creditHour,
    'courseCatagory': courseCatagory,
    'courseDetail': courseDetail,
    'section': section,
    "day": day,
    "time": time,
    'labSection': labSection,
    'labDay': labDay,
    'labTime': labTime,
    'completePercentage': completePercentage,
  };
}
