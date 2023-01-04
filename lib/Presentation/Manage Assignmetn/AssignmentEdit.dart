import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:self_task_student/Bloc/Manage%20Assignment/assignment_bloc.dart';
import 'package:self_task_student/Data/Database/SQLite/Model/AssignmentModel.dart';

class AssignmentEdit extends StatefulWidget{
  const AssignmentEdit({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AssignmentEdit();
}

class _AssignmentEdit extends State<AssignmentEdit>{

  final AssignmentBloc assignmentBloc = AssignmentBloc();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _assignmentName = TextEditingController();
  final TextEditingController _assignmentDesc = TextEditingController();
  final TextEditingController _dueDate = TextEditingController();
  final TextEditingController _dueTime =  TextEditingController();
  bool isLoad = false;

  final user = FirebaseAuth.instance.currentUser!;

  String _typeFirst = 'Assignment';

  @override
  void initState() {
    super.initState();
  }

  Widget build(BuildContext context) {
    final assignment = ModalRoute.of(context)?.settings.arguments as Map;
    int assignmentID = int.parse(assignment['id'].toString());
    int _courseId = int.parse(assignment['courseId'].toString());
    return SafeArea(
        child: Scaffold(
          appBar: AppBar(
            title: const Text("Edit Course Work"),
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
            create: ((context) {
              assignmentBloc.add(GetSpecificAssignment(assignmentID));
              return assignmentBloc;
            }),
            child: BlocBuilder<AssignmentBloc, AssignmentState>(builder:(context, state){
              if(state is AssignmentInitial){
                return const Center(child: CircularProgressIndicator(color: Colors.red,));
              }else if(state is AssignmentLoading){
                return const Center(child: CircularProgressIndicator(color: Colors.green,));
              }else if(state is UpdateAssignmentState){
                if(isLoad == false){
                  isLoad = true;
                  _assignmentName.text = state.model.assignmentName;
                  _assignmentDesc.text = state.model.assignmentDesc!;
                  _typeFirst = state.model.type;
                  _dueDate.text = state.model.dueDate;
                  _dueTime.text = state.model.dueTime;
                }

                return ListView(
                  children: [
                    Form(
                      key: _formKey,
                      child: Padding(
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
                                        id: assignmentID,
                                        assignmentName: _assignmentName.text,
                                        assignmentDesc: _assignmentDesc.text,
                                        type: _typeFirst,
                                        dueDate: _dueDate.text,
                                        dueTime: _dueTime.text,
                                        userId: user.uid,
                                        courseId: _courseId,
                                        isComplete: state.model.isComplete,
                                      );

                                      assignmentBloc.add(UpdateAssignmentData(assignmentModel));

                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Data Added Successfully'),
                                            backgroundColor: Colors.green,
                                          )
                                      );

                                      Navigator.pop(context);
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
                      ),
                    )
                  ],
                );
              }else{
                return const Center(child: Text('Error'));
              }
            }),

          ),
        )
    );
  }

  Widget assignmentNameWidget() {
    return TextFormField(
      controller: _assignmentName,
      validator: (value){
        if (value == null || value.isEmpty) {
          return 'Please enter Assignment Title';
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