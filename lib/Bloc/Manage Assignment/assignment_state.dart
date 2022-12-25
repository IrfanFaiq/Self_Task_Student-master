part of 'assignment_bloc.dart';

abstract class AssignmentState extends Equatable {
  const AssignmentState();
}

class AssignmentInitial extends AssignmentState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AssignmentLoading extends AssignmentState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
class AssignmentError extends AssignmentState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}


class GetAssignmentState extends AssignmentState{
  final List<AssignmentModel> listAssignment;
  const GetAssignmentState(this.listAssignment);

  @override
  List<Object?> get props => [listAssignment];
}

class UpdateAssignmentState extends AssignmentState{
  final AssignmentModel model;
  const UpdateAssignmentState(this.model);
  @override
  // TODO: implement props
  List<Object?> get props => [model];
}

