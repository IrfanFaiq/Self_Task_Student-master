import 'package:flutter/material.dart';
import 'package:self_task_student/View/Settings/Manage%20Subject/SubjectList.dart';

import 'CheckBoxState.dart';

class EditSubject extends StatefulWidget {
  const EditSubject({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _EditSubject();
}

class _EditSubject extends State<EditSubject> {
  final lectureDays = [
    CheckBoxState(title: 'Monday'),
    CheckBoxState(title: 'Tuesday'),
    CheckBoxState(title: 'Wednesday'),
    CheckBoxState(title: 'Thursday'),
    CheckBoxState(title: 'Friday'),
  ];

  final labDays = [
    CheckBoxState(title: 'Monday'),
    CheckBoxState(title: 'Tuesday'),
    CheckBoxState(title: 'Wednesday'),
    CheckBoxState(title: 'Thursday'),
    CheckBoxState(title: 'Friday'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text('Edit Course'),
              centerTitle: true,
              backgroundColor: Colors.green,
            ),
            body: Padding(
                padding: EdgeInsets.symmetric(horizontal: 40),
                child: ListView(
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          children: [Text('Course Name')],
                        ),
                        SizedBox(height: 10),
                        _cName(),
                        SizedBox(height: 10),
                        Row(
                          children: [Text('Course Code')],
                        ),
                        _cCode(),
                        SizedBox(height: 10),
                        Row(
                          children: [Text('Course Section')],
                        ),
                        _cSection(),
                        SizedBox(height: 10),
                        Row(
                          children: [Text('Lab Section')],
                        ),
                        _labSection(),
                        SizedBox(height: 10),
                        Row(
                          children: [Text('Lecture')],
                        ),
                        ...lectureDays.map(_checkBoxList).toList(),
                        SizedBox(height: 10),
                        Row(
                          children: [Text('Lab')],
                        ),
                        ...labDays.map(_checkBoxList).toList(),
                        SizedBox(height: 10),
                        _ConfirmButton(context),
                      ],
                    )
                  ],
                ))));
  }

  Widget _cName() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Full Name',
      ),
    );
  }

  Widget _cCode() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Email',
      ),
    );
  }

  Widget _cSection() {
    return TextFormField(
      decoration: InputDecoration(
        hintText: 'Phone number',
      ),
    );
  }

  Widget _labSection() {
    return TextFormField(
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        hintText: 'Matrix ID',
      ),
    );
  }

  Widget _daysCheckBox(day) {
    bool isCheck = false;
    return CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        title: Text(day),
        value: isCheck,
        onChanged: (bool? value) {
          setState(() {
            isCheck = value!;
          });
        });
  }

  Widget _ConfirmButton(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
            context, MaterialPageRoute(builder: (context) => SubjectList()));
      },
      style: ElevatedButton.styleFrom(
          primary: Colors.green,
          fixedSize: const Size(300, 60),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(50))),
      child: Text('Confirm'),
    );
  }

  Widget _checkBoxList(CheckBoxState checkbox) => CheckboxListTile(
        controlAffinity: ListTileControlAffinity.leading,
        value: checkbox.value,
        title: Text(checkbox.title),
        onChanged: (value) => setState(() => checkbox.value = value!),
      );
}
