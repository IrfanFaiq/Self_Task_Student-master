import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:self_task_student/Bloc/Manage%20Course/course_bloc.dart';
import 'package:self_task_student/Data/Database/SQLite/Model/CourseListModel.dart';
import 'package:self_task_student/Data/Database/SQLite/Model/UserCourseModel.dart';

import '../../View/Settings/Manage Subject/CheckBoxState.dart';
//TODO: make the get from json much faster by declaring the list outside and call the list in if esle


class AddSubject extends StatefulWidget {
  const AddSubject({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _AddSubject();
}

class _AddSubject extends State<AddSubject> {
  List data = [];

  @override
  void initState() {

    super.initState();
  }

  void onCodeChange(state) {
    setState(() {
      _selectedCourseCode = state;
    });
  }

  final lectureDays = [
    CheckBoxState(title: 'Monday'),
    CheckBoxState(title: 'Tuesday'),
    CheckBoxState(title: 'Wednesday'),
    CheckBoxState(title: 'Thursday'),
    CheckBoxState(title: 'Friday'),
  ];


  List<String> labDays = [
    "Monday",
    "Tuesday",
    "Wednesday",
    "Thursday",
    "Friday",
  ];


  List<CourseListModel> courseCode = [];
  List coreCourse = [];
  List courseUniversity = [];
  List courseMath = [];
  CourseListModel _selectedCourseCode = CourseListModel(courseCode: "courseCode", courseName: "courseName", courseCredit: 12, isLab: 1);
  String? category;
  TimeOfDay selectedClassTime = TimeOfDay.now();
  TimeOfDay selectedLabTime = TimeOfDay.now();
  String? _courseCatagory;
  final CourseBloc courseBloc = CourseBloc();
  final user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();
  int _isLab = 1;
  int _is2ndClass = 1;
  int? labDayEnabled;
  bool isThereLabDayTime = true;
  String _courseDay = 'Monday';
  String? _labDay;
  final TextEditingController _courseCode = TextEditingController();
  final TextEditingController _courseName = TextEditingController();
  final TextEditingController _creditHour = TextEditingController();
  final TextEditingController _courseSection = TextEditingController();
  final TextEditingController _labSection = TextEditingController();
  final TextEditingController _classTime = TextEditingController();
  final TextEditingController? _labTime = TextEditingController();
  final TextEditingController? _courseDetail = TextEditingController();


  @override
  Widget build(BuildContext context) {
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
              title: Text('Add Subject'),
              centerTitle: true,
              backgroundColor: Colors.green,
            ),
            body: Form(
                     key: _formKey,
                     child: ListView(
                       children: [
                         Padding(
                           padding: const EdgeInsets.symmetric(horizontal: 40),
                           child: Column(
                             crossAxisAlignment: CrossAxisAlignment.stretch,
                             mainAxisAlignment: MainAxisAlignment.center,
                             children: [
                               _cCatagory(),
                               const SizedBox(height: 15),
                               _cCode(),
                               const SizedBox(height: 15),
                               _cName(),
                               const SizedBox(height: 15),
                               _cCreditHour(),
                               const SizedBox(height: 15),
                               _cLectureSection(),
                               const SizedBox(height: 15),
                               _lSection(),
                               const SizedBox(height: 15),
                               _cDay(),
                               const SizedBox(height: 5),
                               _cTime(),
                               const SizedBox(height: 15),
                               _lDay(),
                               const SizedBox(height: 5),
                               _lTime(),
                               const SizedBox(height: 5),
                               _cDetail(),
                               const SizedBox(height: 15),
                               Material(
                                 elevation: 8,
                                 shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
                                 child:Container(
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
                                         if(_isLab == 1){
                                           UserCourseModel userCourseModel = UserCourseModel(
                                             userId: user.uid,
                                             courseCode: _courseCode.text,
                                             courseName: _courseName.text,
                                             creditHour: _creditHour.text.toString(),
                                             courseCatagory: _courseCatagory!,
                                             section: _courseSection.text,
                                             day: _courseDay,
                                             time: _classTime.text,
                                             labSection: _labSection.text,
                                             labDay: _labDay,
                                             labTime: _labTime?.text,
                                             courseDetail: _courseDetail?.text,
                                             completePercentage: 0,
                                           );
                                           courseBloc.add(CreateUserCourseData(userCourseModel));
                                         } else{
                                           UserCourseModel userCourseModel = UserCourseModel(
                                             userId: user.uid,
                                             courseCode: _courseCode.text,
                                             courseName: _courseName.text,
                                             creditHour: _creditHour.text.toString(),
                                             courseCatagory: _courseCatagory!,
                                             section: _courseSection.text,
                                             day: _courseDay,
                                             time: _classTime.text,
                                             labDay: _labDay,
                                             labTime: _labTime?.text,
                                             courseDetail: _courseDetail?.text,
                                             completePercentage: 0,
                                           );
                                           courseBloc.add(CreateUserCourseData(userCourseModel));
                                         }

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
                                     child: Text('Confirm'),
                                   ),
                                 ) ,
                               )
                             ],
                           ),
                         )
                       ],
                     )
                 )

              ),
        );
  }

  Widget _cCatagory(){
    return DropdownButtonFormField(
        validator: (value) {
          if (value == null) {
            return 'Please enter course catogory';
          }
          return null;
        },
        decoration: InputDecoration(
          label: Text("Course Catagory"),
        ),
        value: _courseCatagory,
        items: <String>['Core Course', 'University Course', 'Math Course']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        elevation: 16,
        onChanged: (String? newValue) {
          setState(() {
            _courseCatagory = newValue!;
            print(_courseCatagory);
            print(category);
            switch (_courseCatagory) {
              case "Core Course":
                {
                  if(category != "Core Course"){
                    data=[];
                    data = coreCourse;
                  }
                  category="Core Course";
                }
                break;
              case "University Course":
                {
                  if(category != "University Course"){
                    data=[];
                    data = courseUniversity;
                  }
                  category = "University Course";
                }
                break;
              case "Math Course":
                {
                  if(category != "Math Course"){
                    data=[];
                    data = courseMath;
                  }
                  category = "Math Course";
                }
                break;
              default:
                {
                  data = [];
                }
                break;
            }

            _labDay=null;
            print(category);
          });
        });
  }

  Widget _cCode(){
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      controller: _courseCode,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        label: Text('Course Code'),
      ),
    );
  }

  Widget _cName(){
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      controller: _courseName,
      keyboardType: TextInputType.text,
      decoration: InputDecoration(
        label: Text('Course Name'),
      ),
    );
  }

  Widget _cCreditHour(){
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      controller: _creditHour,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text('Credit Hour'),
      ),
    );
  }

  Widget _cLectureSection() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      controller: _courseSection,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        label: Text('Lecture Section'),
      ),
    );
  }

  Widget _lSection() {
    bool isThere = true;
    if(_isLab == 1){
      isThere = true;
    }else{
      isThere = false;
      _labSection?.clear();
    }
    return TextFormField(
      enabled: isThere,
      controller: _labSection,
      decoration: InputDecoration(
        label: Text('Lab Section (if any)'),
      ),
    );
  }

  Widget _cDay() {
    return DropdownButtonFormField(
        validator: (value) {
          if (value == null) {
            return 'Please enter some text';
          }
          return null;
        },
        decoration: InputDecoration(
          label: Text("CLass Day"),
        ),
        value: _courseDay,
        items: <String>['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        elevation: 16,
        onChanged: (String? newValue) {
          setState(() {
            _courseDay = newValue!;
          });
        });
  }

  Widget _lDay() {

    if(_isLab == 1 || _is2ndClass == 1){
      isThereLabDayTime = true;
    }else{
      isThereLabDayTime = false;
      _labDay=null;
    }
    return DropdownButtonFormField(
        value: _labDay,
        enableFeedback: isThereLabDayTime,
        decoration: InputDecoration(
          label: Text("Lab / 2nd CLass Day"),
        ),
        items: labDays.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        elevation: 16,
        onChanged: isThereLabDayTime ? (String? anotherValue) {
          setState(() {
            _labDay = anotherValue!;
          });
        } : null,
    );
  }

  Widget _cTime(){
    return TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
      controller: _classTime,
      readOnly: true,
      onTap: () async {
        await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((value) {
          setState(() {
            selectedClassTime = value!;
          });
        });
        _classTime.text = selectedClassTime.format(context);
      },
      decoration: InputDecoration(// add padding to adjust text
        contentPadding: EdgeInsets.only(top: 15),
        label: Text("Class Time"),
        prefixIcon: Icon(Icons.access_time, size: 25),
        suffixIcon: IconButton(
          onPressed: _classTime.clear,
          icon: Icon(Icons.clear),
        )
      )
    );
  }

  bool isThere(){

    if(_isLab == 1){
      return true;
    }else{
      return false;
    }
  }

  Widget _lTime(){
    if(_isLab == 1 || _is2ndClass == 1){
      isThereLabDayTime = true;
    }else{
      isThereLabDayTime = false;
      _labTime?.clear();
    }
    return TextField(
      controller: _labTime,
      readOnly: true,
      enabled: isThereLabDayTime,
      onTap: () async {
        await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        ).then((value) {
          selectedLabTime = value!;
        });;

        _labTime?.text = selectedLabTime.format(context);
      },
      decoration: InputDecoration(// add padding to adjust text
          contentPadding: EdgeInsets.only(top: 15),
          label: Text("Lab / 2nd Class Time"),
          prefixIcon: Icon(Icons.access_time, size: 25),
          suffixIcon: IconButton(
            onPressed: _classTime.clear,
            icon: Icon(Icons.clear),
          )
      )
    );
  }

  Widget _cDetail(){
    return TextFormField(
        controller: _courseDetail,
        minLines: 3,
        maxLines: 3,
        decoration: InputDecoration(
          label: Text('Assesment Detail'),
        )
    );
  }

}
