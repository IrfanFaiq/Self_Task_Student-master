import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_task_student/Bloc/Manage%20Assignment/assignment_bloc.dart';
import 'package:self_task_student/Presentation/Manage%20Assignmetn/AssignmentEdit.dart';
import 'AssignmentAdd.dart';

class AssignmentList extends StatefulWidget{
  const AssignmentList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AssignmentList();
}

class _AssignmentList extends State<AssignmentList>{

  final AssignmentBloc assignmentBloc = AssignmentBloc();
  final user = FirebaseAuth.instance.currentUser!;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final course = ModalRoute.of(context)?.settings.arguments as Map;
    int courseId = int.parse(course['id'].toString());
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Task List "),
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
              //Calling add task button
              _addTaskButton(context, courseId),
            ],
          ),
          body: Container(
            margin: const EdgeInsets.all(8),
            child: BlocProvider(
              create: (context){
                assignmentBloc.add(GetUserAssignment(user.uid, courseId));
                return assignmentBloc;},
              child: BlocBuilder<AssignmentBloc, AssignmentState>(builder:(context, state){
                if (state is AssignmentInitial) {
                  return const Center(child: CircularProgressIndicator(color: Colors.red,));

                } else if (state is AssignmentLoading) {
                  return const Center(child: CircularProgressIndicator());

                } else if (state is GetAssignmentState) {
                  if(state.listAssignment.length == 0){
                    return Center(child: Text("Please add a task"));
                  }else{
                    return _getAssignmentList(context, state.listAssignment, assignmentBloc);
                  }

                } else {
                  return const Center(child: Text("No data"));
                }
              }),
            )
          ),
        ),
    );
  }

  Widget _addTaskButton(BuildContext context,int courseId){
    return Padding(
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
                      builder: (context) => const AssignmentAdd(),
                      settings: RouteSettings(
                        arguments: {
                          "courseId": courseId,
                        },
                      )
                  )).then((_) => setState((){
                assignmentBloc.add(GetUserAssignment(user.uid, courseId));
              }));
            },
            child: const Text('Add Task'),
          ),
        ),
      ),
    );
  }

  Widget _getAssignmentList(BuildContext context, state, assignmentBloc){
    return ListView.builder(
      itemCount: state == null ? 0 : state.length,
      itemBuilder: (context, index){
        return GestureDetector(
          onTap: (){},
          child: Card(
            elevation: 2,
            margin: const EdgeInsets.symmetric(horizontal: 10,vertical: 6),
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
                                      state[index].assignmentName.toString(),
                                      style: const TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [

                                    ],
                                  )
                                ],
                              ),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.edit),
                                    onPressed: () {

                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => const AssignmentEdit(),
                                              settings: RouteSettings(
                                                arguments: {
                                                  "id": state[index].id.toString(),
                                                  "courseId": state[index].courseId.toString(),
                                                },
                                              ))).then((_)=>setState((){
                                        assignmentBloc.add(GetUserAssignment(user.uid, state[index].courseId));
                                      }));

                                    },
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red,),
                                    onPressed: () {
                                      assignmentBloc.add(DeleteAssignmentData(state[index].id));
                                      setState((){
                                        assignmentBloc.add(GetUserAssignment(user.uid, state[index].courseId));
                                      });
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),

                          Padding(
                            padding: EdgeInsets.only(left: 8, right: 8),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Task Description: ${state[index].assignmentDesc}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black87),
                                ),

                                Text("Task Type: ${state[index].type}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black87),
                                ),

                                Text("Task Date: ${state[index].dueDate}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black87),
                                ),

                                Text("Task Time: ${state[index].dueTime}",
                                  style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.normal,
                                      color: Colors.black87),
                                ),
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
}