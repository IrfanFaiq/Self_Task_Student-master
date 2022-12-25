import 'package:flutter/material.dart';
import 'package:self_task_student/Presentation/Manage%20Subject/AddSubject.dart';
import 'package:self_task_student/View/Settings/Manage%20Subject/editSubject.dart';
import 'package:settings_ui/settings_ui.dart';

class CourseMenu extends StatefulWidget {
  const CourseMenu({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _CourseMenu();
}

class _CourseMenu extends State<CourseMenu> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
      appBar: AppBar(
        title: Text('Mange Subject'),
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
          title: Text("Edit Course Details"),
          onPressed: (context) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => EditSubject(),
            ));
          },
        ),
        SettingsTile(
          title: Text("Manage Assment"),
          onPressed: (context) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AddSubject(),
            ));
          },
        ),
        SettingsTile(
          title: Text("Move to archive"),
          leading: Icon(Icons.archive),
          onPressed: (context) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AddSubject(),
            ));
          },
        ),
        SettingsTile(
          title: const Text(
            "Delete Course",
            style: TextStyle(color: Colors.red),
          ),
          leading: Icon(Icons.delete, color: Colors.red),
          onPressed: (context) {
            Navigator.of(context).push(MaterialPageRoute(
              builder: (_) => AddSubject(),
            ));
          },
        ),
      ]),
    ]);
  }
}
