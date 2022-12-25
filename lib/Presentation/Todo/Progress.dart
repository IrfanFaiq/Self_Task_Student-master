import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';
import 'package:self_task_student/Bloc/Manage%20Assignment/assignment_bloc.dart';
import 'package:self_task_student/Presentation/Todo/AssignmentToDo.dart';

import '../../Bloc/Manage Course/course_bloc.dart';

class Progress extends StatefulWidget {
  const Progress({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _ProgressScreen();
}

class _ProgressScreen extends State<Progress> {
  final user = FirebaseAuth.instance.currentUser!;
  final CourseBloc courseBloc = CourseBloc();
  final AssignmentBloc assignmentBloc = AssignmentBloc();



  @override
  void initState(){
    courseBloc.add(GetAllCourse(user.uid));
    super.initState();
  }

  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topRight,
                end: Alignment.bottomLeft,
                colors: <Color>[Colors.blue, Colors.green]),
          ),
        ),
        title: Text('Work Progression'),
        //Text('Class Progression'),
        centerTitle: true,
      ),
          body: Container(
            margin: const EdgeInsets.all(8),
            child: BlocProvider(
              create: (_) => courseBloc,
              child: BlocBuilder<CourseBloc, CourseState>(builder: (context, state){
                if(state is CourseInitial){
                  return const Center(child: CircularProgressIndicator(color: Colors.red));
                }else if (state is CourseLoading){
                  return const Center(child: CircularProgressIndicator(color: Colors.red));
                }else if (state is GetAllLoad){
                  if(state.listData.length == 0){
                    return Center(child: Text("Please add a subject"));
                  }else {
                    return RefreshIndicator(
                      onRefresh: () async {
                        courseBloc.add(GetAllCourse(user.uid));
                      },
                      child: ListView.builder(
                        itemCount: state.listData == null ? 0 : state.listData
                            .length,
                        itemBuilder: (context, index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (
                                          context) => const AssignmentToDo(),
                                      settings: RouteSettings(
                                        arguments: {
                                          "id": state.listData[index].id
                                              .toString(),
                                        },
                                      ))).then((_) =>
                                  setState(() {
                                    courseBloc.add(GetAllCourse(user.uid));
                                  }));
                            },
                            child: Card(
                              elevation: 3,
                              margin: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 9),
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(
                                        child: Container(
                                          width: width,
                                          padding: const EdgeInsets.only(
                                              bottom: 8),
                                          child: Column(
                                            mainAxisAlignment: MainAxisAlignment
                                                .center,
                                            crossAxisAlignment: CrossAxisAlignment
                                                .start,
                                            children: [
                                              Row(
                                                mainAxisAlignment: MainAxisAlignment
                                                    .start,
                                                children: [
                                                  Padding(
                                                    padding:
                                                    const EdgeInsets.only(
                                                        left: 8, right: 8),
                                                    child: SizedBox(
                                                      width: width -70,
                                                      child: Text(
                                                        "${state.listData[index].courseCode} - ${state.listData[index].courseName} ",
                                                        style: const TextStyle(
                                                            fontSize: 14,
                                                            fontWeight: FontWeight
                                                                .bold),
                                                      ),
                                                    ),
                                                  ),
                                                  Column(
                                                    crossAxisAlignment: CrossAxisAlignment
                                                        .end,
                                                    mainAxisAlignment: MainAxisAlignment
                                                        .start,
                                                    children: [
                                                    ],
                                                  )
                                                ],
                                              ),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    left: 8, right: 8, top: 8),
                                                child: LinearPercentIndicator(
                                                  width: MediaQuery
                                                      .of(context)
                                                      .size
                                                      .width - 80,
                                                  animation: true,
                                                  lineHeight: 20.0,
                                                  animationDuration: 2000,
                                                  percent: state.listData[index]
                                                      .completePercentage,
                                                  center: Text("${state
                                                      .listData[index]
                                                      .completePercentage *
                                                      100} %"),
                                                  linearStrokeCap: LinearStrokeCap
                                                      .roundAll,
                                                  progressColor: Colors
                                                      .greenAccent,
                                                ),
                                              ),
                                            ],
                                          ),
                                        )
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  }

                }else{
                  return const Center(child: Text('error'));
                }
              })
            ),
          )
    ));
  }
}
