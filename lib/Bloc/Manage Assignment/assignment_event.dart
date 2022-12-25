part of 'assignment_bloc.dart';

abstract class AssignmentEvent extends Equatable {
  const AssignmentEvent();
}

class GetUserAssignment extends AssignmentEvent{
  final String userId;
  final int courseId;
  const GetUserAssignment(this.userId, this.courseId);

  @override
  // TODO: implement props
  List<Object?> get props => [userId, courseId];

}

class GetAssignmentDate extends AssignmentEvent{
  final String userId;
  final String dueDate;
  const GetAssignmentDate(this.userId, this.dueDate);

  @override
  List<Object?> get props => [userId,dueDate];
}

class GetSpecificAssignment extends AssignmentEvent{
  final int id;
  const GetSpecificAssignment(this.id);

  @override
  List<Object?> get props => [id];
}

class CreateAssignmentData extends AssignmentEvent{
  final AssignmentModel model;
  const CreateAssignmentData(this.model);

  @override
  List<Object?> get props => [model];
}

class UpdateAssignmentData extends AssignmentEvent{
  final AssignmentModel assignmentModel;
  const UpdateAssignmentData(this.assignmentModel);

  @override
  // TODO: implement props
  List<Object?> get props => [assignmentModel];
}

class DeleteAssignmentData extends AssignmentEvent{
  final int assignmentid;
  const DeleteAssignmentData(this.assignmentid);

  @override
  // TODO: implement props
  List<Object?> get props => [assignmentid];
}

class UpdateIsCompleteData extends AssignmentEvent{
  final int assignmentID;
  final int newIsComplete;

  const UpdateIsCompleteData(this.assignmentID, this.newIsComplete);

  @override
  List<Object?> get props => [assignmentID, newIsComplete];

}
