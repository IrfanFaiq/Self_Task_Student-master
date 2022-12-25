import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:self_task_student/Data/Database/SQLite/Model/ReminderModel.dart';
import 'package:self_task_student/Data/Database/SQLite/Provider/ReminderProvider.dart';

part 'reminder_event.dart';
part 'reminder_state.dart';

class ReminderBloc extends Bloc<ReminderEvent, ReminderState> {
  ReminderBloc() : super(ReminderInitial()) {
    ReminderProvider reminderProvider = ReminderProvider();

    on<CreateReminderEvent>((event, emit) async {
      await reminderProvider.createReminder(event.modelCreate);
    });

    on<UpdateReminderEvent>((event, emit) async {
      await reminderProvider.updateReminder(event.modelUpadate);
    });

    on<DeleteReminderEvent>((event, emit) async {
      await reminderProvider.deleteReminder(event.idDelete);
    });

    on<GetAllReminderEvent>((event, emit) async {
      emit(ReminderLoading());
      final listReminder = await reminderProvider.getAllReminderWithDate(
          event.userId, event.date);
      emit(GetAllReminderState(listReminder));
    });

    on<GetSpecificReminderEvent>((event, emit) async {
      emit(ReminderLoading());
      final reminderData = await reminderProvider.getSpecificReminder(event.id);
      emit(GetSpecificReminderState(reminderData));
    });
  }
}
