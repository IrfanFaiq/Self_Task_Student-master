import 'dart:convert';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_task_student/Presentation/Manage%20Subject/AddSubject.dart';
import 'package:self_task_student/Presentation/Manage%20Subject/EditSubject.dart';
import 'package:self_task_student/Presentation/Manage%20Assignmetn/AssignmentList.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../Bloc/Manage Course/course_bloc.dart';

class SubjectList extends StatefulWidget{
  const SubjectList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubjectList();

  //TODO: Delete the assignment that is associated with the deleted course
}

class _SubjectList extends State<SubjectList>{
  final CourseBloc courseBloc = CourseBloc();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    courseBloc.add(GetAllCourse(user.uid));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text('Current Subjects'),
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
          bottomNavigationBar: Stack(
            clipBehavior: Clip.none,
            alignment: const FractionalOffset(0.5, 0.3),
            children: [
              Container(
                height: 40.0,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 12.0, right: 12.0),

                child: Material(
                  elevation: 8,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(25)),
                      gradient: LinearGradient(
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [
                          Colors.greenAccent,
                          Colors.lightBlue
                        ],
                      ),
                    ),
                    child: ElevatedButton(

                      style: ElevatedButton.styleFrom(
                          primary: Colors.transparent,
                          fixedSize: const Size(300, 60),
                          shape:
                          RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const AddSubject()),
                        ).then((_) => setState(() {
                          courseBloc.add(GetAllCourse(user.uid));
                        }));
                      },
                      child: const Text('Add Subject'),
                    ),
                  ),
                ),

              ),
            ],
          ),
          body: Container(
            margin: const EdgeInsets.all(8),
            child: BlocProvider(
              create: (_) => courseBloc,
              child: BlocBuilder<CourseBloc,CourseState>(builder: (context, state){
                if (state is CourseInitial) {
                  return const Center(child: CircularProgressIndicator());

                } else if (state is CourseLoading) {
                  return const Center(child: CircularProgressIndicator());

                } else if (state is GetAllLoad) {
                  if(state.listData.length == 0){
                    return Center(child: Text("Please add a subject"));
                  }else{
                    return _getUserCourseList(context, state.listData, courseBloc);
                  }

                } else {
                  return const Center(child: Text("error"));
                }
              }),
            ),
          ),
        )
    );
  }



  Widget _getUserCourseList(BuildContext context, state, userBloc){
    return ListView.builder(
        itemCount: state == null ? 0 : state.length,
        itemBuilder: (context, index){
          return GestureDetector(
              onTap: (){},
              child: Card(
                elevation: 5,
                margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding:
                                        const EdgeInsets.only(left: 8, right: 8),

                                        child: Text(
                                          state[index].courseCode,
                                          style: const TextStyle(
                                              fontSize: 14,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ),


                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [

                                      IconButton(
                                        icon: const Icon(Icons.assignment),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => const AssignmentList(),
                                                  settings: RouteSettings(
                                                    arguments: {
                                                      "id": state[index].id.toString(),
                                                    },
                                                  ))).then((_) => setState(() {}));
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.edit),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) => const EditSubject(),
                                                  settings: RouteSettings(
                                                    arguments: {
                                                      "id": state[index].id.toString(),
                                                    },
                                                  ))).then((_)=>setState((){
                                            courseBloc.add(GetAllCourse(user.uid));
                                          }));
                                        },
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete, color: Colors.red,),
                                        onPressed: () {
                                          courseBloc.add(DeleteUserCourseData(state[index].id));
                                          setState((){
                                            courseBloc.add(GetAllCourse(user.uid));
                                          });
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              Padding(
                                padding: const EdgeInsets.only(left: 8, right: 8),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Course Name: ${state[index].courseName}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      "Credit Hour: ${state[index].creditHour}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      "Class Section: ${state[index].section}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      "Class Day: ${state[index].day}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),
                                    Text(
                                      "Class Time: ${state[index].time}",
                                      style: const TextStyle(
                                          fontSize: 12,
                                          fontWeight: FontWeight.normal,
                                          color: Colors.black),
                                    ),
                                    _labSection(state[index].labSection),
                                    _labDay(state[index].labDay),
                                    _labTime(state[index].labTime),
                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
        },
    );
  }

  Widget _settingList() {
    return SettingsList(sections: [
      SettingsSection(tiles: [
        // SettingsTile(
        //   title: Text("Temp SEP"),
        //   onPressed: (context) {
        //     Navigator.of(context).push(MaterialPageRoute(
        //       builder: (_) => CourseMenu(),
        //     ));
        //   },
        // ),
        SettingsTile(
          title: const Text("Add Subject"),
          leading: const Icon(Icons.add),
          onPressed: (context) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => const AddSubject(),
            ));
          },
        )
      ]),
    ]);
  }


  Widget _labSection(String? labSection) {
    if(labSection == null){
      return Container();
    }else{
      return Text(
        "Lab Section: $labSection",
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.black),
      );
    }
  }

  Widget _labDay(String? labDay){
    if(labDay == null){
      return Container();
    }else{
      return Text(
        "Lab Day: $labDay",
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.black),
      );
    }
  }

  Widget _labTime(String? labTime){
    if(labTime == null){
      return Container();
    }else{
      return Text(
        "Lab Time: $labTime",
        style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.normal,
            color: Colors.black),
      );
    }
  }
}


