import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:self_task_student/Data/Database/SQLite/Model/AssignmentModel.dart';
import 'package:self_task_student/Data/Database/SQLite/Provider/AssignmentProvider.dart';

part 'assignment_event.dart';
part 'assignment_state.dart';

class AssignmentBloc extends Bloc<AssignmentEvent, AssignmentState> {
  AssignmentBloc() : super(AssignmentInitial()) {

    final AssignmentProvider assignmentProvider = AssignmentProvider();

    on<GetUserAssignment>((event, emit) async{
      emit(AssignmentLoading());
      final listAssignment = await assignmentProvider.getAssignmentData(event.userId, event.courseId);
      emit(GetAssignmentState(listAssignment));
    });

    on<GetAssignmentDate>((event, emit) async{
      emit(AssignmentLoading());
      final listAssignment = await assignmentProvider.getAssignmentDateData(event.userId, event.dueDate);
      emit(GetAssignmentState(listAssignment));
    });

    on<CreateAssignmentData>((event, emit) async {
      print("objectsssss");
      await assignmentProvider.addAssignmentData(event.model);
    });

    on<UpdateAssignmentData>((event, emit) async{
      await assignmentProvider.updateAssignmentData(event.assignmentModel);
    });

    on<GetSpecificAssignment>((event, emit) async{
      emit(AssignmentLoading());
      final specificAssignment = await assignmentProvider.getSpecificAssignmentData(event.id);
      emit(UpdateAssignmentState(specificAssignment));
    });

    on<DeleteAssignmentData>((event, emit) async{
      await assignmentProvider.deleteAssignmentData(event.assignmentid);
    });

    on<UpdateIsCompleteData>((event, emit) async{
      await assignmentProvider.updateIsCompleteData(event.assignmentID, event.newIsComplete);
    });
  }
}
