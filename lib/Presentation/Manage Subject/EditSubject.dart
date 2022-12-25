import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:self_task_student/Bloc/Authenticate/auth_bloc.dart';
import 'package:self_task_student/Bloc/Manage%20Course/course_bloc.dart';
import 'package:self_task_student/Data/Database/SQLite/Model/CourseListModel.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:async';
import 'package:self_task_student/Data/Database/SQLite/Model/UserCourseModel.dart';
import 'package:self_task_student/View/Settings/Manage%20Subject/SubjectList.dart';

import '../../View/Settings/Manage Subject/CheckBoxState.dart';


class EditSubject extends StatefulWidget {
  const EditSubject({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditSubject();
}

class _EditSubject extends State<EditSubject> {
  List data = [];
  String? _mySelection;
  @override
  void initState(){
    getCore();
    getUniversity();
    getMath();
    super.initState();
  }

  bool isLoad = false;
  bool isLoad2nd = false;
  List<CourseListModel> courseCode = [];
  TimeOfDay selectedClassTime = TimeOfDay.now();
  TimeOfDay selectedLabTime = TimeOfDay.now();
  String? category;
  bool isThereLabDayTime = false;
  final CourseBloc courseBloc = CourseBloc();
  final user = FirebaseAuth.instance.currentUser!;
  final _formKey = GlobalKey<FormState>();
  int _isLab = 0;
  int _is2ndClass = 0;
  String _courseDay = 'Monday';
  String? _labDay;
  String? _courseCategory;
  final TextEditingController _courseName = TextEditingController();
  final TextEditingController _courseCode = TextEditingController();
  final TextEditingController _courseSection = TextEditingController();
  final TextEditingController? _labSection = TextEditingController();
  final TextEditingController _classTime = TextEditingController();
  final TextEditingController? _labTime = TextEditingController();
  final TextEditingController? _courseDetail = TextEditingController();
  int _creditHour = 0;
  int courseID=0;
  int index = 0;
  List coreCourse = [];
  List courseUniversity = [];
  List courseMath = [];

  @override
  void dispose(){
    super.dispose();
    _courseName.dispose();
    _courseCode.dispose();
    _courseSection.dispose();
    _classTime.dispose();
    _labSection?.dispose();
    _labTime?.dispose();
    _courseDetail?.dispose();
  }

  Widget build(BuildContext context) {
    final course = ModalRoute.of(context)?.settings.arguments as Map;
    courseID = int.parse(course['id'].toString());

    return SafeArea(
      child: Scaffold(
          appBar: AppBar(
            title: Text('Edit Subject'),
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
            create: ((_) {
              courseBloc.add(GetSpecificUserCourse(courseID));
              return courseBloc;
            }),
            child: BlocBuilder<CourseBloc, CourseState>(builder: (context,state){


              if (state is CourseInitial){
                return const CircularProgressIndicator();
              }
              else if(state is CourseLoading){
                return const CircularProgressIndicator();
              }
              else if (state is GetSpecificLoad){
                // print("TEST");
                // _courseCode.text = state.model.courseCode;
                // print(_courseCode.text);
                // _courseName.text = state.model.courseName;
                // _courseSection.text = state.model.section;
                // _courseDay = state.model.day;
                // _classTime.text = state.model.time;
                // if(state.model.labSection!=null){
                //   _labSection?.text = state.model.labSection!;
                // }
                // if(state.model.labTime!=null){
                //   _labTime?.text = state.model.labTime!;
                // }
                // _labDay = state.model.labDay;
                // _courseSelected = "${state.model.courseCode} - ${state.model.courseName}";
                // cTime = _classTime.text;
                // lTime = _labTime?.text;
                // cDay = _courseDay;
                // lDay =_labDay;
                if(isLoad == false){
                  _courseName.text = state.model.courseName;
                  _courseCode.text = state.model.courseCode;
                  isLoad = true;
                  _courseSection.text = state.model.section;
                  _courseDay = state.model.day;
                  _classTime.text = state.model.time;
                  _labDay = state.model.labDay;
                  if(state.model.labSection != null){
                    _labSection?.text = state.model.labSection!;
                    _isLab=1;
                  }
                  if(state.model.labTime != null){
                    _labTime?.text = state.model.labTime!;
                  }

                  if(state.model.courseDetail != null){
                    _courseDetail?.text = state.model.courseDetail!;
                  }
                  _courseCategory = state.model.courseCatagory;

                  _mySelection = state.model.courseCode;
                }
                print(index);
                index++;
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
                            _cCatagory(state.model.courseCode),
                            const SizedBox(height: 15),
                            _dropDown(context),
                            const SizedBox(height: 15),
                            _cSection(),
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
                            const SizedBox(height: 100),
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
                                    print(_courseCode.text);
                                    if(_formKey.currentState!.validate()){
                                      if(_isLab == 1){
                                        UserCourseModel userCourseModel = UserCourseModel(
                                          id: courseID,
                                          userId: user.uid,
                                          courseCode: _courseCode.text,
                                          courseName: _courseName.text,
                                          creditHour: _creditHour.toString(),
                                          courseCatagory: _courseCategory!,
                                          section: _courseSection.text,
                                          day: _courseDay,
                                          time: _classTime.text,
                                          labSection: _labSection?.text,
                                          labDay: _labDay,
                                          labTime: _labTime?.text,
                                          courseDetail: _courseDetail?.text,
                                          completePercentage: state.model.completePercentage,
                                        );
                                        courseBloc.add(UpdateUserCourseData(userCourseModel));
                                      } else{
                                        UserCourseModel userCourseModel = UserCourseModel(
                                          id: courseID,
                                          userId: user.uid,
                                          courseCode: _courseCode.text,
                                          courseName: _courseName.text,
                                          creditHour: _creditHour.toString(),
                                          courseCatagory: _courseCategory!,
                                          section: _courseSection.text,
                                          day: _courseDay,
                                          time: _classTime.text,
                                          labDay: _labDay,
                                          labTime: _labTime?.text,
                                          courseDetail: _courseDetail?.text,
                                          completePercentage: state.model.completePercentage,
                                        );
                                        courseBloc.add(UpdateUserCourseData(userCourseModel));
                                      }
                                      // UserCourseModel userCourseModel = UserCourseModel(courseCode: _courseCode.text, section: _courseSection.text, day: _courseDay, time: 'one', labSection: _labSection?.text, labDay: _labDay, labTime: null, userId: user.uid, courseName: '', creditHour: null);


                                      ScaffoldMessenger.of(context).showSnackBar(
                                          const SnackBar(content: Text('Data Added Successfully'),
                                            backgroundColor: Colors.green,
                                          )
                                      );
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.transparent,
                                      fixedSize: const Size(300, 60),
                                      shape:
                                      RoundedRectangleBorder(borderRadius: BorderRadius.circular(25))),
                                  child: Text('Confirm'),
                                ),
                              ),
                            )

                          ],
                        ),
                      )
                    )
                  ],
                );

              }
              else{
                print("else");
                return const Text("error");
              }
            }),

          )
      ),
    );
  }





  Future<String> getCore() async {
    var res = await http
        .get(Uri.parse("https://json-selftask.herokuapp.com/coreCourse"), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      coreCourse = resBody;
    });

    print(resBody);

    return "Sucess";
  }
  Future<String> getUniversity() async {
    var res = await http
        .get(Uri.parse("https://json-selftask.herokuapp.com/universityCourse"), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      courseUniversity = resBody;
    });

    print(resBody);

    return "Sucess";
  }
  Future<String> getMath() async {
    var res = await http
        .get(Uri.parse("https://json-selftask.herokuapp.com/mathCourse"), headers: {"Accept": "application/json"});
    var resBody = json.decode(res.body);

    setState(() {
      courseMath = resBody;
    });

    print(resBody);

    return "Sucess";
  }
  Widget _cCatagory(String courseCode){
    if(isLoad2nd == false){

      switch (_courseCategory) {
        case "Core Course":
          {
            if(category != "Core Course"){
              data=[];
              _mySelection = null;
              data = coreCourse;
            }
            category = "Core Course";
          }
          break;
        case "University Course":
          {
            if(_courseCategory != "University Course"){
              data=[];
              _mySelection = null;
              data = courseUniversity;
            }
            category="University Course";
          }
          break;
        case "Math Course":
          {
            if(_courseCategory != "Math Course"){
              data=[];
              _mySelection = null;
              data = courseMath;
            }
            category="Math Course";
          }
          break;
        default:
          {
            _mySelection = null;
            data = [];
            category=null;
          }
          break;
      }
      _mySelection = courseCode;
      isLoad2nd = true;
    }

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
        value: _courseCategory,
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
            _courseCategory = newValue!;
            switch (_courseCategory) {
              case "Core Course":
                {
                  if(category != "Core Course"){
                    data=[];
                    _mySelection = null;
                    getCore();
                  }
                  category="Core Course";
                }
                break;
              case "University Course":
                {
                  if(category != "University Course"){
                    data=[];
                    _mySelection = null;
                    getUniversity();
                  }
                  category = "University Course";
                }
                break;
              case "Math Course":
                {
                  if(category != "Math Course"){
                    data=[];
                    _mySelection = null;
                    getMath();
                  }
                  category = "Math Course";
                }
                break;
              default:
                {
                  _mySelection = null;
                  data = [];
                }
                break;
            }
          });
        });
  }

  Widget _dropDown(BuildContext context){
    return DropdownButtonFormField(
        validator: (value) {
          if (value == null) {
            return 'Please select the course';
          }
          return null;
        },
        decoration: InputDecoration(
          label: Text("Course Selection"),
        ),
        isExpanded: true,
        value: _mySelection,
        items: data.map((item) {
          return DropdownMenuItem(
            onTap: (){
              _isLab = item['isLab'];
              _is2ndClass = item['is2ndClass'];
              if(_isLab == "0"){
                _labSection?.clear();
              }
              if(_is2ndClass == "0"){
                _labTime?.clear();
                _labDay=null;
              }
              _courseName.text = item['courseName'].toString();
              _courseCode.text = item['courseCode'].toString();
              _creditHour = int.parse(item['courseCredit'].toString());

            },
            child: Text("${item['courseCode']} - ${item['courseName']}"),
            value: item['courseCode'].toString(),

          );
        }).toList(),
        onChanged: (newVal) {
          setState(() {
            _mySelection = newVal as String?;

          });
        });
  }


  Widget _cDetail(){
    return TextFormField(
      controller: _courseDetail,
      decoration: InputDecoration(
        label: Text('Assessment Detail'),
      ),
      minLines: 3,
      maxLines: 3,
    );
  }



  Widget _cSection() {
    return TextFormField(
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
      controller: _courseSection,
      decoration: InputDecoration(
        label: Text('Course Section'),
      ),
    );
  }

  Widget _lSection() {
    bool isThere = false;
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

          _courseDay = newValue!;

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
        decoration: InputDecoration(
          label: Text("Lab / 2nd CLass Day"),
        ),
        value: _labDay,
        items: <String>['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday']
            .map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
        elevation: 16,
        onChanged: isThereLabDayTime?(String? anotherValue) {
          _labDay = anotherValue!;
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
            selectedClassTime = value!;
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


  Widget _lTime(){
    if(_isLab == 1 || _is2ndClass == 1){
      isThereLabDayTime = true;
    }else{
      isThereLabDayTime = false;
      _labTime?.clear();
    }
    return TextFormField(
        controller: _labTime,
        readOnly: true,
        onTap: () async {
          await showTimePicker(
            context: context,
            initialTime: TimeOfDay.now(),
          ).then((value) {
            selectedLabTime = value!;
          });
          _labTime?.text = selectedLabTime.format(context);
        },
        decoration: InputDecoration(// add padding to adjust text
            contentPadding: EdgeInsets.only(top: 15),
            label: Text("Lab Time"),
            prefixIcon: Icon(Icons.access_time, size: 25),
            suffixIcon: IconButton(
              onPressed: _classTime.clear,
              icon: Icon(Icons.clear),
            )
        )
    );
  }





}
