part of 'reminder_bloc.dart';

abstract class ReminderState extends Equatable {
  const ReminderState();
}

class ReminderInitial extends ReminderState {
  @override
  List<Object> get props => [];
}

class ReminderLoading extends ReminderState {
  @override
  List<Object> get props => [];
}

class GetAllReminderState extends ReminderState {
  final List<ReminderModel> listReminder;
  const GetAllReminderState(this.listReminder);
  @override
  List<Object> get props => [listReminder];
}

class GetSpecificReminderState extends ReminderState {
  final ReminderModel modelReminder;
  const GetSpecificReminderState(this.modelReminder);
  @override
  List<Object> get props => [modelReminder];
}
