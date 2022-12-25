import 'package:equatable/equatable.dart';

class ReminderModel extends Equatable {
  final int? id;
  final String titleReminder;
  final String descriptionReminder;
  final String dateReminder;
  final String timeReminder;
  final String userId;

  const ReminderModel({
    this.id,
    required this.titleReminder,
    required this.descriptionReminder,
    required this.dateReminder,
    required this.timeReminder,
    required this.userId,
  });

  factory ReminderModel.fromJson(Map<String, dynamic> json) {
    return ReminderModel(
        id: json['id'],
        titleReminder: json['titleReminder'],
        descriptionReminder: json['descriptionReminder'],
        dateReminder: json['dateReminder'],
        timeReminder: json['timeReminder'],
        userId: json['userId']);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'titleReminder': titleReminder,
        'descriptionReminder': descriptionReminder,
        'dateReminder': dateReminder,
        'timeReminder': timeReminder,
        'userId': userId,
      };

  @override
  List<Object?> get props => [
        id,
        titleReminder,
        descriptionReminder,
        dateReminder,
        timeReminder,
        userId,
        userId,
      ];
}
