part of 'course_bloc.dart';

@immutable
abstract class CourseEvent extends Equatable {
  const CourseEvent();
  @override
  List<Object> get props => [];
}

class GetAllCourse extends CourseEvent {
  final String userId;
  const GetAllCourse(this.userId);
}


class GetSpecificUserCourse extends CourseEvent {
  final int userCourseId;
  const GetSpecificUserCourse(this.userCourseId);
}

class CreateUserCourseData extends CourseEvent {
  final UserCourseModel userCourseModel;
  const CreateUserCourseData(this.userCourseModel);
}

class UpdateUserCourseData extends CourseEvent {
  final UserCourseModel userCourseModel;
  const UpdateUserCourseData(this.userCourseModel);
}

class DeleteUserCourseData extends CourseEvent {
  final int userCourseId;
  const DeleteUserCourseData(this.userCourseId);
}

class ListCourseJson extends CourseEvent{
}

class UpdateWorkPercentage extends CourseEvent{
  final int courseId;
  const UpdateWorkPercentage(this.courseId);
}
