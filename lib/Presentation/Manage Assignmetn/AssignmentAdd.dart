import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:self_task_student/Bloc/Manage%20Assignment/assignment_bloc.dart';
import 'package:self_task_student/Data/Database/SQLite/Model/AssignmentModel.dart';
import 'package:self_task_student/Presentation/Manage%20Subject/AddSubject.dart';

import 'AssignmentList.dart';

class AssignmentAdd extends StatefulWidget{
  const AssignmentAdd({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AssignmentAdd();
}

class _AssignmentAdd extends State<AssignmentAdd>{

  final AssignmentBloc assignmentBloc = AssignmentBloc();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _assignmentName = TextEditingController();
  final TextEditingController _assignmentDesc = TextEditingController();
  final TextEditingController _dueDate = TextEditingController();
  final TextEditingController _dueTime =  TextEditingController();

  final user = FirebaseAuth.instance.currentUser!;

  String _typeFirst = 'Assignment';

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final course = ModalRoute.of(context)?.settings.arguments as Map;
    int _courseId = int.parse(course['courseId'].toString());
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Add Course Work"),
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
        body: BlocProvider(
          create: (context) => assignmentBloc,
          child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        assignmentNameWidget(),
                        const SizedBox(height: 15),
                        assignmentDescWidget(),
                        const SizedBox(height: 15),
                        typeWidget(),
                        const SizedBox(height: 15),
                        dueDateWidget(),
                        const SizedBox(height: 15),
                        dueTimeWidget(),
                        const SizedBox(height: 25),
                        Material(
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
                              onPressed: () async{
                                if(_formKey.currentState!.validate()){

                                  AssignmentModel assignmentModel = AssignmentModel(
                                    assignmentName: _assignmentName.text,
                                    assignmentDesc: _assignmentDesc.text,
                                    type: _typeFirst,
                                    dueDate: _dueDate.text,
                                    dueTime: _dueTime.text,
                                    userId: user.uid,
                                    courseId: _courseId,
                                    isComplete: 0,
                                  );

                                  assignmentBloc.add(CreateAssignmentData(assignmentModel));

                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text('Data Added Successfully'),
                                        backgroundColor: Colors.green,
                                      )
                                  );

                                  Navigator.of(context).pop();

                                  // Navigator.pushAndRemoveUntil(
                                  //     context,
                                  //     MaterialPageRoute(
                                  //         settings: RouteSettings(
                                  //           arguments: {
                                  //             "id": _courseId,
                                  //           }
                                  //         ),
                                  //         builder: (BuildContext context) =>
                                  //         const AssignmentList()),
                                  //         (Route<dynamic> route) => false);

                                }
                              },
                              style: ElevatedButton.styleFrom(
                                  primary: Colors.transparent,
                                  fixedSize: const Size(300, 60),
                                  shape:
                                  RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                              child: const Text('Confirm'),
                            ),
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              )
          ),

        ),
      )
    );
  }

  Widget assignmentNameWidget() {
    return TextFormField(
      controller: _assignmentName,
      validator: (value){
        if (value == null || value.isEmpty) {
          return 'Please enter Assessment Title';
        }
        return null;
      },
      decoration: const InputDecoration(
        label: Text('Assessment Title'),
      ),
    );
  }

  Widget assignmentDescWidget(){
    return TextFormField(
      minLines: 3,
      maxLines: 3,
      controller: _assignmentDesc,
      decoration: const InputDecoration(
        label: Text('Assessment Description (optional)'),
      ),
    );
  }

  Widget typeWidget(){
    return DropdownButtonFormField(
        validator: (value) {
          if (value == null) {
            return 'Please enter Assessment type';
          }
          return null;
        },
      decoration: const InputDecoration(
        label: Text('Course Assessment Type'),
      ),
      value: _typeFirst,
      elevation: 16,
      items: <String>['Assignment', 'Quiz', 'Project', 'Exam']
          .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
      onChanged: (String? newValue){
        setState(() {
          _typeFirst = newValue!;
        });
      }
    );
  }
  DateTime selectedDate = DateTime.now();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        _dueDate.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Widget dueDateWidget(){
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a date';
        }
        return null;
      },
      controller: _dueDate,
      readOnly: true,
      decoration: const InputDecoration(
        label: Text('Due Date'),
      ),
      onTap: () => _selectDate(context),
    );
  }

  TimeOfDay selectedTime = TimeOfDay.now();
  Widget dueTimeWidget(){
    return TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter a time';
          }
          return null;
        },
        controller: _dueTime,
        readOnly: true,
        onTap: () async {
          await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          ).then((value) {
            setState(() {
              selectedTime = value!;
            });
          });;
          _dueTime.text = selectedTime.format(context);
        },
        decoration: InputDecoration(// add padding to adjust text
            contentPadding: const EdgeInsets.only(top: 15),
            label: const Text("Class Time"),
            prefixIcon: const Icon(Icons.access_time, size: 25),
            suffixIcon: IconButton(
              onPressed: _dueTime.clear,
              icon: const Icon(Icons.clear),
            )
        )
    );
  }


}