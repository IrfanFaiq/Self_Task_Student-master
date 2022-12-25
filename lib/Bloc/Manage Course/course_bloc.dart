import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:meta/meta.dart';
import 'package:self_task_student/Data/Database/SQLite/Model/CourseListModel.dart';
import 'package:self_task_student/Data/Database/SQLite/Model/UserCourseModel.dart';
import 'package:self_task_student/Data/Database/SQLite/Provider/JsonProvider.dart';
import 'package:self_task_student/Data/Database/SQLite/Provider/UserCourseProvider.dart';

part 'course_event.dart';
part 'course_state.dart';

class CourseBloc extends Bloc<CourseEvent, CourseState> {
  CourseBloc() : super(CourseInitial()) {
    final UserCourseProvider userCourseProvider = UserCourseProvider();
    final JsonPovider jsonPovider = JsonPovider();

    on<GetAllCourse>((event, emit) async{
      emit(CourseLoading());
      final listUserCourse = await userCourseProvider.getAllCourseData(event.userId);
      emit(GetAllLoad(listUserCourse));
    });

    // on<GetAllUserCourse>((event, emit) async{
    //   emit(CourseLoading());
    //   final listUserCourse = await userCourseProvider.getAllUserCourseData(event.userId);
    //   emit(GetUserLoad(listUserCourse));
    // });

    on<GetSpecificUserCourse>((event, emit) async{
      emit(CourseLoading());
      final specificUserCourse = await userCourseProvider.getSpecificUserCourseData(event.userCourseId);
      emit(GetSpecificLoad(specificUserCourse));
    });

    on<CreateUserCourseData>((event, emit) async{
      await userCourseProvider.saveCourseData(event.userCourseModel);
    });

    on<UpdateUserCourseData>((event, emit) async{
      await userCourseProvider.updateData(event.userCourseModel);
    });

    on<DeleteUserCourseData>((event, emit) async{
      await userCourseProvider.deleteData(event.userCourseId);
    });

    on<ListCourseJson>((event, emit) async{
      emit(CourseLoading());
      final listCourse = await jsonPovider.fetchCourseJson();
      emit(CourseJsonState(listCourse));
    });

    on<UpdateWorkPercentage>((event, emit) async{
      await userCourseProvider.updatePercentage(event.courseId);
    });
  }
}
