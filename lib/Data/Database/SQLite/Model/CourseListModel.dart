class CourseListModel {
  final String courseCode;
  final String courseName;
  final int courseCredit;
  final int isLab;

  CourseListModel({
    required this.courseCode,
    required this.courseName,
    required this.courseCredit,
    required this.isLab,
  });

  factory CourseListModel.fromJson(Map<String, dynamic> json) {
    return CourseListModel(
        courseCode: json['courseCode'],
        courseName: json['courseName'],
        courseCredit: json['courseCredit'],
        isLab: json['isLab']);
  }

  Map<String, dynamic> toJson() => {
        'courseCode': courseCode,
        "courseName": courseName,
        "courseCredit": courseCredit,
        "isLab": isLab
      };

}
