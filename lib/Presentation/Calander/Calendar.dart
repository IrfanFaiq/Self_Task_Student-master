import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:self_task_student/Bloc/Calander/reminder_bloc.dart';
import 'package:self_task_student/Bloc/Manage%20Assignment/assignment_bloc.dart';
import 'package:self_task_student/Bloc/Manage%20Course/course_bloc.dart';
import 'package:self_task_student/Data/Database/SQLite/Model/AssignmentModel.dart';
import 'package:self_task_student/Data/Database/SQLite/Model/ReminderModel.dart';
import 'package:self_task_student/Data/Database/SQLite/Provider/AssignmentProvider.dart';
import 'package:self_task_student/Data/Database/SQLite/Provider/ReminderProvider.dart';
import 'package:self_task_student/Data/Database/SQLite/Repository/UserCourseRepository.dart';
import '../../Bloc/service/remindNoti.dart';
import '../Dashboard/SettingMenu.dart';
import 'package:table_calendar/table_calendar.dart';
import '../Manage Assignmetn/AssignmentList.dart';
import '../Todo/AssignmentToDo.dart';
import '../Todo/Progress.dart';

class Calendar extends StatefulWidget {
  const Calendar({Key? key}) : super(key: key);
  @override
  _Calendar createState() => _Calendar();
}

class _Calendar extends State<Calendar> {
  final _formKey = GlobalKey<FormState>();
  DateTime _focusDay = DateTime.now();
  DateTime _selectedDay = DateTime.now();
  AssignmentBloc assignmentBloc = AssignmentBloc();
  ReminderBloc reminderBloc = ReminderBloc();
  final TextEditingController _reminderTitle = TextEditingController();
  final TextEditingController _reminderDesc = TextEditingController();
  final TextEditingController _reminderTime = TextEditingController();
  final user = FirebaseAuth.instance.currentUser!;
  List<AssignmentModel> events = [];
  List<ReminderModel> reminderEvents = [];
  ReminderProvider reminderProvider = ReminderProvider();
  AssignmentProvider assignmentProvider = AssignmentProvider();

  void main() async {
    List<AssignmentModel> eventTemp =
        await assignmentProvider.getAssignmentDateWithoutDate(user.uid);
    List<ReminderModel> reminderTemp =
        await reminderProvider.getAllReminderWithoutDate(user.uid);
    setState(() {
      events = eventTemp;
      reminderEvents = reminderTemp;
    });
  }

  @override
  void initState() {
    main();
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    String dateNow = dateFormat.format(_focusDay);
    assignmentBloc.add(GetAssignmentDate(user.uid, dateNow));
    reminderBloc.add(GetAllReminderEvent(user.uid, dateNow));
    super.initState();
  }

  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          title: const Text('Calander'),
          centerTitle: true,
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: <Color>[Colors.blue, Colors.green]),
            ),
          ),
        ),
        body: MultiBlocProvider(
            providers: [
              BlocProvider(create: (context) {
                DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                String dateNow = dateFormat.format(_focusDay);
                assignmentBloc.add(GetAssignmentDate(user.uid, dateNow));
                return assignmentBloc;
              }),
              BlocProvider(create: (context) {
                DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                String dateNow = dateFormat.format(_focusDay);
                reminderBloc.add(GetAllReminderEvent(user.uid, dateNow));
                return reminderBloc;
              }),
            ],
            child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: SingleChildScrollView(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        TableCalendar(
                          focusedDay: _focusDay,
                          eventLoader: (date) {
                            DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                            String d1 = dateFormat.format(date);

                            for (int i = 0; i < events.length; i++) {
                              if (d1 == events[i].dueDate) {
                                return [date];
                              }
                            }
                            for (int i = 0; i < reminderEvents.length; i++) {
                              if (d1 == reminderEvents[i].dateReminder) {
                                return [date];
                              }
                            }
                            return [];
                          },
                          selectedDayPredicate: (day) =>
                              isSameDay(_selectedDay, day),
                          onDaySelected: (selectedDay, focusDay) {
                            if (!isSameDay(_selectedDay, selectedDay)) {
                              setState(() {
                                _selectedDay = selectedDay;
                                _focusDay = focusDay;
                                DateFormat dateFormat =
                                    DateFormat("yyyy-MM-dd");
                                String dateNow =
                                    dateFormat.format(_selectedDay);
                                assignmentBloc
                                    .add(GetAssignmentDate(user.uid, dateNow));
                                reminderBloc.add(
                                    GetAllReminderEvent(user.uid, dateNow));
                              });
                            }
                          },
                          firstDay: DateTime.utc(2010, 10, 16),
                          lastDay: DateTime.utc(2030, 3, 14),
                          locale: 'en_US',
                          startingDayOfWeek: StartingDayOfWeek.monday,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(
                              DateFormat('EEEE, dd MMMM, yyyy')
                                  .format(_selectedDay),
                              style: Theme.of(context).textTheme.headline6,
                            )
                          ],
                        ),
                        SizedBox(
                          height: 250,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                BlocBuilder<AssignmentBloc, AssignmentState>(
                                    builder: (context, state) {
                                  if (state is AssignmentLoading) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  } else if (state is GetAssignmentState) {
                                    if (state.listAssignment.isNotEmpty) {
                                      return SizedBox(
                                        child: Column(
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.only(top: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    "Work",
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyMedium,
                                                  )
                                                ],
                                              ),
                                            ),
                                            ListView.builder(
                                                physics:
                                                    NeverScrollableScrollPhysics(),
                                                shrinkWrap: true,
                                                itemCount:
                                                    state.listAssignment == null
                                                        ? 0
                                                        : state.listAssignment
                                                            .length,
                                                itemBuilder: (context, index) {
                                                  return GestureDetector(
                                                    onTap: () {},
                                                    child: Card(
                                                      elevation: 8,
                                                      child: ListTile(
                                                        leading: Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          crossAxisAlignment:
                                                              CrossAxisAlignment
                                                                  .center,
                                                          children: [
                                                            circleColor(state
                                                                .listAssignment[
                                                                    index]
                                                                .type)
                                                          ],
                                                        ),
                                                        title: Text(
                                                            "${state.listAssignment[index].assignmentName}"),
                                                        subtitle: Text(state
                                                            .listAssignment[
                                                                index]
                                                            .dueTime),
                                                        trailing:
                                                            PopupMenuButton(
                                                          child: Icon(
                                                              Icons.more_vert),
                                                          onSelected: (value) {
                                                            DateFormat
                                                                dateFormat =
                                                                DateFormat(
                                                                    "yyyy-MM-dd");
                                                            String dateNow =
                                                                dateFormat.format(
                                                                    _focusDay);
                                                            switch (value) {
                                                              case "info":
                                                                {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => const AssignmentList(),
                                                                          settings: RouteSettings(
                                                                            arguments: {
                                                                              "id": state.listAssignment[index].courseId,
                                                                            },
                                                                          ))).then((_) => setState(() {
                                                                        assignmentBloc.add(GetAssignmentDate(
                                                                            user.uid,
                                                                            dateNow));
                                                                        reminderBloc.add(GetAllReminderEvent(
                                                                            user.uid,
                                                                            dateNow));
                                                                      }));
                                                                }
                                                                break;
                                                              case "todo":
                                                                {
                                                                  Navigator.push(
                                                                      context,
                                                                      MaterialPageRoute(
                                                                          builder: (context) => const AssignmentToDo(),
                                                                          settings: RouteSettings(
                                                                            arguments: {
                                                                              "id": state.listAssignment[index].courseId,
                                                                            },
                                                                          ))).then((_) => setState(() {
                                                                        assignmentBloc.add(GetAssignmentDate(
                                                                            user.uid,
                                                                            dateNow));
                                                                        reminderBloc.add(GetAllReminderEvent(
                                                                            user.uid,
                                                                            dateNow));
                                                                      }));
                                                                }
                                                                break;
                                                            }
                                                          },
                                                          itemBuilder: (BuildContext
                                                                  context) =>
                                                              <
                                                                  PopupMenuEntry<
                                                                      String>>[
                                                            const PopupMenuItem<
                                                                String>(
                                                              value: 'info',
                                                              child: Text(
                                                                  'View Assignment'),
                                                            ),
                                                            const PopupMenuItem<
                                                                String>(
                                                              value: 'todo',
                                                              child: Text(
                                                                  'View Todo'),
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  );
                                                })
                                          ],
                                        ),
                                      );
                                    } else {
                                      return Container();
                                    }
                                  } else {
                                    return const Center(child: Text("error"));
                                  }
                                }),
                                BlocBuilder<ReminderBloc, ReminderState>(
                                    builder: (context, state) {
                                  if (state is GetAllReminderState) {
                                    if (state.listReminder.isNotEmpty) {
                                      return SizedBox(
                                          child: Column(
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(top: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              children: [
                                                Text(
                                                  "Reminder",
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                )
                                              ],
                                            ),
                                          ),
                                          ListView.builder(
                                              physics:
                                                  NeverScrollableScrollPhysics(),
                                              shrinkWrap: true,
                                              itemCount: state.listReminder ==
                                                      null
                                                  ? 0
                                                  : state.listReminder.length,
                                              itemBuilder: (context, index) {
                                                return GestureDetector(
                                                  onTap: () {},
                                                  child: Card(
                                                    elevation: 8,
                                                    child: ListTile(
                                                      leading: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .center,
                                                        children: [
                                                          const Icon(
                                                            Icons.circle,
                                                            color: Colors.blue,
                                                          )
                                                        ],
                                                      ),
                                                      title: Text(
                                                          "${state.listReminder[index].titleReminder}"),
                                                      subtitle: Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .start,
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .start,
                                                        children: [
                                                          SizedBox(
                                                              child: Text(
                                                                  "${state.listReminder[index].descriptionReminder}")),
                                                          Text(
                                                              "${state.listReminder[index].timeReminder}")
                                                        ],
                                                      ),
                                                      trailing: PopupMenuButton(
                                                        child: Icon(
                                                            Icons.more_vert),
                                                        onSelected: (value) {
                                                          switch (value) {
                                                            case "delete":
                                                              {
                                                                print(value);
                                                                DateFormat
                                                                    dateFormat =
                                                                    DateFormat(
                                                                        "yyyy-MM-dd");
                                                                String dateNow =
                                                                    dateFormat
                                                                        .format(
                                                                            _focusDay);
                                                                reminderBloc.add(
                                                                    DeleteReminderEvent(state
                                                                        .listReminder[
                                                                            index]
                                                                        .id!));
                                                                reminderBloc.add(
                                                                    GetAllReminderEvent(
                                                                        user.uid,
                                                                        dateNow));
                                                              }
                                                              break;
                                                            case "edit":
                                                              {
                                                                print(value);
                                                                showDialog(
                                                                    context:
                                                                        context,
                                                                    builder:
                                                                        (context) {
                                                                      _reminderTitle.text = state
                                                                          .listReminder[
                                                                              index]
                                                                          .titleReminder;
                                                                      _reminderDesc.text = state
                                                                          .listReminder[
                                                                              index]
                                                                          .descriptionReminder;
                                                                      _reminderTime.text = state
                                                                          .listReminder[
                                                                              index]
                                                                          .timeReminder;
                                                                      return SizedBox(
                                                                        child:
                                                                            AlertDialog(
                                                                          title:
                                                                              const Text("Edit Reminder"),
                                                                          content: Container(
                                                                              height: 200,
                                                                              child: Form(
                                                                                key: _formKey,
                                                                                child: Column(children: [
                                                                                  TextFormField(
                                                                                    controller: _reminderTitle,
                                                                                    validator: (value) {
                                                                                      if (value == null || value.isEmpty) {
                                                                                        return "Please insert the title";
                                                                                      }
                                                                                    },
                                                                                    decoration: const InputDecoration(
                                                                                      label: Text("Title"),
                                                                                    ),
                                                                                  ),
                                                                                  TextFormField(
                                                                                    controller: _reminderDesc,
                                                                                    decoration: const InputDecoration(
                                                                                      label: Text("Description"),
                                                                                    ),
                                                                                  ),
                                                                                  timeSelector(),
                                                                                ]),
                                                                              )),
                                                                          actions: [
                                                                            ElevatedButton(
                                                                                style: ElevatedButton.styleFrom(
                                                                                  primary: Colors.blue,
                                                                                ),
                                                                                onPressed: () {
                                                                                  DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                                                                                  String dateNow = dateFormat.format(_focusDay);
                                                                                  if (_formKey.currentState!.validate()) {
                                                                                    ReminderModel reminderModel = ReminderModel(id: state.listReminder[index].id, titleReminder: _reminderTitle.text, dateReminder: dateNow, timeReminder: _reminderTime.text, userId: user.uid, descriptionReminder: _reminderDesc.text);

                                                                                    reminderBloc.add(UpdateReminderEvent(reminderModel));
                                                                                    _reminderTitle.clear();
                                                                                    _reminderDesc.clear();
                                                                                    _reminderTime.clear();
                                                                                    reminderBloc.add(GetAllReminderEvent(user.uid, dateNow));
                                                                                    Navigator.of(context).pop();
                                                                                  }
                                                                                },
                                                                                child: const Text("Confirm")),
                                                                          ],
                                                                        ),
                                                                      );
                                                                    });
                                                              }
                                                              break;
                                                          }
                                                        },
                                                        itemBuilder: (BuildContext
                                                                context) =>
                                                            <
                                                                PopupMenuEntry<
                                                                    String>>[
                                                          const PopupMenuItem<
                                                              String>(
                                                            value: "edit",
                                                            child: Text('Edit'),
                                                          ),
                                                          const PopupMenuItem<
                                                              String>(
                                                            value: "delete",
                                                            child: Text(
                                                              "Delete",
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),
                                                );
                                              })
                                        ],
                                      ));
                                    } else {
                                      return Container();
                                    }
                                  } else {
                                    return const Center(
                                        child: CircularProgressIndicator());
                                  }
                                })
                              ],
                            ),
                          ),
                        ),
                      ]),
                ))),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Add Reminder"),
                    content: Container(
                        height: 200,
                        child: Form(
                          key: _formKey,
                          child: Column(children: [
                            TextFormField(
                              controller: _reminderTitle,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return "Please insert the title";
                                }
                              },
                              decoration: const InputDecoration(
                                label: Text("Title"),
                              ),
                            ),
                            TextFormField(
                              controller: _reminderDesc,
                              decoration: const InputDecoration(
                                label: Text("Description"),
                              ),
                            ),
                            timeSelector(),
                          ]),
                        )),
                    actions: [
                      ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            primary: Colors.blue,
                          ),
                          onPressed: () {
                            DateFormat dateFormat = DateFormat("yyyy-MM-dd");
                            String dateNow = dateFormat.format(_focusDay);
                            if (_formKey.currentState!.validate()) {
                              ReminderModel reminderModel = ReminderModel(
                                  titleReminder: _reminderTitle.text,
                                  dateReminder: dateNow,
                                  timeReminder: _reminderTime.text,
                                  userId: user.uid,
                                  descriptionReminder: _reminderDesc.text);

                              sendQueryReminderNotification(reminderModel);
                              reminderBloc
                                  .add(CreateReminderEvent(reminderModel));
                              _reminderTitle.clear();
                              _reminderDesc.clear();
                              _reminderTime.clear();
                              reminderBloc
                                  .add(GetAllReminderEvent(user.uid, dateNow));

                              Navigator.of(context).pop();
                            }
                          },
                          child: const Text("Confirm")),
                    ],
                  );
                });
          },
        ),
      ),
    );
  }

  Widget _calendarView() {
    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    return TableCalendar(
      focusedDay: _focusDay,
      // eventLoader:(day) {
      //   DateTime d = DateTime.now()
      //   if(day == d){
      //     return events[]
      //   }
      // },
      selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
      onDaySelected: (selectedDay, focusDay) {
        if (!isSameDay(_selectedDay, selectedDay)) {
          setState(() {
            _selectedDay = selectedDay;
            _focusDay = focusDay;
            String dateNow = dateFormat.format(_selectedDay);
            assignmentBloc.add(GetAssignmentDate(user.uid, dateNow));
            reminderBloc.add(GetAllReminderEvent(user.uid, dateNow));
          });
        }
      },
      firstDay: DateTime.utc(2010, 10, 16),
      lastDay: DateTime.utc(2030, 3, 14),
      locale: 'en_US',
      startingDayOfWeek: StartingDayOfWeek.monday,
    );
  }

  TimeOfDay selectedTime = TimeOfDay.now();
  Widget timeSelector() {
    return TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        controller: _reminderTime,
        readOnly: true,
        onTap: () async {
          await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          ).then((value) {
            setState(() {
              selectedTime = value!;
            });
          });
          ;
          _reminderTime.text = selectedTime.format(context);
        },
        decoration: InputDecoration(
            // add padding to adjust text
            contentPadding: const EdgeInsets.only(top: 15),
            label: const Text("Class Time"),
            prefixIcon: const Icon(Icons.access_time, size: 25),
            suffixIcon: IconButton(
              onPressed: _reminderTime.clear,
              icon: const Icon(Icons.clear),
            )));
  }

  Widget circleColor(String type) {
    if (type == "Assignment") {
      return const Icon(
        Icons.circle,
        color: Colors.green,
      );
    } else if (type == "Exam") {
      return const Icon(
        Icons.circle,
        color: Colors.red,
      );
    } else if (type == "Quiz") {
      return const Icon(
        Icons.circle,
        color: Colors.yellow,
      );
    } else if (type == "Project") {
      return const Icon(
        Icons.circle,
        color: Colors.purpleAccent,
      );
    } else {
      return Icon(Icons.circle);
    }
  }
}
