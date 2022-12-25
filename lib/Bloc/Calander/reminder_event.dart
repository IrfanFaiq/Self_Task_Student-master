part of 'reminder_bloc.dart';

abstract class ReminderEvent extends Equatable {
  const ReminderEvent();
}

class CreateReminderEvent extends ReminderEvent {
  final ReminderModel modelCreate;
  const CreateReminderEvent(this.modelCreate);

  @override
  List<Object?> get props => [modelCreate];
}

class UpdateReminderEvent extends ReminderEvent {
  final ReminderModel modelUpadate;
  const UpdateReminderEvent(this.modelUpadate);

  @override
  List<Object?> get props => [modelUpadate];
}

class DeleteReminderEvent extends ReminderEvent {
  final int idDelete;
  const DeleteReminderEvent(this.idDelete);

  @override
  // TODO: implement props
  List<Object?> get props => [idDelete];
}

class GetAllReminderEvent extends ReminderEvent {
  final String userId;
  final String date;
  const GetAllReminderEvent(this.userId, this.date);

  @override
  // TODO: implement props
  List<Object?> get props => [userId, date];
}

class GetSpecificReminderEvent extends ReminderEvent {
  final int id;
  const GetSpecificReminderEvent(this.id);

  @override
  // TODO: implement props
  List<Object?> get props => [id];
}
