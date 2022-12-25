import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_task_student/Bloc/Manage%20Assignment/assignment_bloc.dart';
import 'package:self_task_student/Bloc/Manage%20Course/course_bloc.dart';

class AssignmentToDo extends StatefulWidget {
  const AssignmentToDo({Key? key}) :super(key: key);

  @override
  State<StatefulWidget> createState() => _AssignmentToDo();
}

class _AssignmentToDo extends State<AssignmentToDo> {

  final user = FirebaseAuth.instance.currentUser!;
  final CourseBloc courseBloc = CourseBloc();
  final AssignmentBloc assignmentBloc = AssignmentBloc();
  bool isChecked = false;

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    Color getColor(Set<MaterialState> states) {
      const Set<MaterialState> interactiveStates = <MaterialState>{
        MaterialState.pressed,
        MaterialState.hovered,
        MaterialState.focused,
      };
      if (states.any(interactiveStates.contains)) {
        return Colors.blue;
      }
      return Colors.green;
    }
    final course = ModalRoute
        .of(context)
        ?.settings
        .arguments as Map;
    int courseId = int.parse(course['id'].toString());
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: const Text('To-Do'),
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
            body: Padding(
              padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: MultiBlocProvider(
                  providers: [
                    BlocProvider(create: (context) {
                      courseBloc.add(GetSpecificUserCourse(courseId));
                      return courseBloc;
                    }),
                    BlocProvider(create: (context) {
                      assignmentBloc.add(GetUserAssignment(user.uid, courseId));
                      return assignmentBloc;
                    }),
                  ],
                  child: Column(

                    children: [
                      BlocBuilder<CourseBloc, CourseState>(
                          builder: (context, state) {
                            if (state is CourseInitial) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is CourseLoading) {
                              return const Center(
                                  child: CircularProgressIndicator());
                            } else if (state is GetSpecificLoad) {
                              return Expanded(
                                child: ListView(
                                  scrollDirection: Axis.horizontal,
                                  children: [
                                    GestureDetector(
                                      onTap: () {},
                                      child: Card(
                                        elevation: 10,
                                        margin: const EdgeInsets.fromLTRB(20, 10, 10, 10),
                                        child: Padding(
                                          padding: EdgeInsets.all(8),
                                          child: SizedBox(
                                              width: width - 55,
                                              child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Course Info:", style: TextStyle(fontWeight: FontWeight.bold),),
                                                  Text("Course Code: ${state.model.courseCode}"),
                                                  Text("Course Name: ${state.model.courseName}"),
                                                  Text("Credit Hour: ${state.model.creditHour}"),
                                                  Text("Class Section: ${state.model.section}"),
                                                  state.model.labSection == null ? Container() : Text("Lab Section: ${state.model.labSection}"),
                                                  Text("Class Day: ${state.model.day}"),
                                                  Text("Class Time: ${state.model.time}"),
                                                  state.model.labDay == null ? Container() : Text("Lab/2nd Class Day: ${state.model.labDay}"),
                                                  state.model.labTime == null ? Container() : Text("Lab/2nd Class Time: ${state.model.labTime}"),
                                                ],
                                              )
                                          ),
                                        ),
                                      ),
                                    ),

                                    GestureDetector(
                                      onTap: () {},
                                      child: Card(
                                        elevation: 10,
                                        margin: const EdgeInsets.fromLTRB(10, 10, 20, 10),
                                        child: SizedBox(
                                          width: width - 40, 
                                          child: Padding(
                                            padding: EdgeInsets.all(10),
                                            child: Column(
                                                mainAxisAlignment: MainAxisAlignment.start,
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text("Assessment Detail:", style: TextStyle(fontWeight: FontWeight.bold),),
                                                  Text("${state.model.courseDetail}"),
                                                 ],
                                              ),
                                          ),
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );



                            } else {
                              return const Center(child: Text("error"));
                            }
                          }),

                      BlocBuilder<AssignmentBloc, AssignmentState>(
                          builder: (context, state) {
                            if(state is AssignmentLoading){
                              return (Text("loading"));
                            }else if(state is GetAssignmentState) {
                              if(state.listAssignment.length == 0){
                                return SizedBox(
                                    height: 450,
                                    width: width,
                                    child: Center(child: Text("Please add a work")),
                                );
                              }else{
                                return SizedBox(
                                    height: 450,
                                  width: width ,
                                    child: ListView.builder(
                                        itemCount: state.listAssignment == null ? 0 : state.listAssignment.length,
                                        itemBuilder: (context, index) {
                                          if(state.listAssignment[index].isComplete == 1){
                                            isChecked = true;
                                          }else{
                                            isChecked = false;
                                          }

                                          return GestureDetector(
                                            onTap: () {},
                                            child: SizedBox(
                                              width: width,
                                              child: Card(
                                                elevation: 10,
                                                margin: EdgeInsets.fromLTRB(20, 10, 20, 10),
                                                child: Padding(
                                                      padding: EdgeInsets.all(8),
                                                      child: Row(
                                                        children: [
                                                          Checkbox(

                                                            value: isChecked,
                                                            onChanged: (bool? value) {

                                                              setState(() {
                                                                isChecked = value!;
                                                                int newValue = 0;
                                                                if(value == true){
                                                                  assignmentBloc.add(UpdateIsCompleteData(state.listAssignment[index].id!, 1));;
                                                                }else{
                                                                  assignmentBloc.add(UpdateIsCompleteData(state.listAssignment[index].id!, 0));
                                                                }

                                                                courseBloc.add(UpdateWorkPercentage(courseId));
                                                                assignmentBloc.add(GetUserAssignment(user.uid, courseId));
                                                              });
                                                            },
                                                          ),
                                                          Column(
                                                            // mainAxisAlignment: MainAxisAlignment.center,
                                                            crossAxisAlignment: CrossAxisAlignment.start,
                                                            children: [
                                                              Text(
                                                                    "Work Title: ${state
                                                                        .listAssignment[index]
                                                                        .assignmentName}"),
                                                              Text(" Description: ${state
                                                                  .listAssignment[index]
                                                                  .assignmentDesc}",
                                                                maxLines: 3,
                                                                softWrap: false,
                                                                overflow: TextOverflow.fade,
                                                              ),
                                                              Text("Work Type: ${state.listAssignment[index].type}"),
                                                              Text("Due Date: ${state
                                                                  .listAssignment[index]
                                                                  .dueDate}"),
                                                              Text("Due Time: ${state
                                                                  .listAssignment[index]
                                                                  .dueTime}"),
                                                            ],
                                                          )
                                                        ],
                                                      )

                                                  ),
                                                ),
                                            ),
                                            );

                                        },
                                      ),

                                );
                              }

                            }else {
                              return const Center(child: Text("error"));
                            }
                          }),
                    ],
                  )),)
        )
    );
  }
}

