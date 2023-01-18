import 'dart:math';

import 'package:awesome_notifications/awesome_notifications.dart';

import '../../Data/Database/SQLite/Model/ReminderModel.dart';

Future<void> sendQueryReminderNotification(ReminderModel reminderModel) async {
  var hourMinuteString = reminderModel.timeReminder;
  var hourMinuteArr = hourMinuteString.split(":");
  int hour1 = int.parse(hourMinuteArr[0]);
  int minute1 = int.parse(hourMinuteArr[1]);

  var date = reminderModel.dateReminder;
  var dateArr = date.split("-");
  var year = int.parse(dateArr[0]);
  var month = int.parse(dateArr[1]);
  var day = int.parse(dateArr[2]);

// Create a new Random object
  final random = Random();

  // Generate a random and unique integer value
  int randomInt = random.nextInt(1000000);

  await AwesomeNotifications().createNotification(
      content: NotificationContent(
        id: randomInt,
        groupKey: '${reminderModel.dateReminder} ${reminderModel.timeReminder}',
        channelKey: 'scheduled_channel',
        title: 'Hey There, Do Not Forget About This!!',
        body: reminderModel.descriptionReminder,
        notificationLayout: NotificationLayout.Default,
      ),
      schedule: NotificationCalendar(
        year: year,
        month: month,
        day: day,
        hour: hour1,
        minute: minute1,
        second: 0,
        millisecond: 0,
        repeats: false,
        allowWhileIdle: true,
      ));
}
