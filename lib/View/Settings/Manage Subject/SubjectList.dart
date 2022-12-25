import 'package:flutter/material.dart';
import 'package:self_task_student/Presentation/Manage%20Subject/AddSubject.dart';
import 'package:self_task_student/View/Settings/Manage%20Subject/CourseMenu.dart';
import 'package:settings_ui/settings_ui.dart';

class SubjectList extends StatefulWidget {
  const SubjectList({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _SubjectList();
}

class _SubjectList extends State<SubjectList> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Current Subject'),
        centerTitle: true,
        backgroundColor: Colors.green,
      ),
      body: _settingList(),
    ));
  }

  Widget _settingList() {
    return SettingsList(sections: [
      SettingsSection(tiles: [
        SettingsTile(
          title: Text("Temp SEP"),
          onPressed: (context) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => CourseMenu(),
            ));
          },
        ),
        SettingsTile(
          title: Text("Add Subject"),
          leading: Icon(Icons.add),
          onPressed: (context) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AddSubject(),
            ));
          },
        )
      ]),
    ]);
  }
}
