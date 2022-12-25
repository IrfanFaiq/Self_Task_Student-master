import 'package:flutter/material.dart';

import 'SettingMenu.dart';
import '../Calander/Calendar.dart';
import '../Todo/Progress.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  PageController _pageController = PageController();
  List<Widget> _screens = [Progress(), Calendar(), SettingMenu()];

  int _selectedIndex = 0;

  void _onPageChange(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void _onItemTapped(int selectedIndex) {
    _pageController.jumpToPage(selectedIndex);
  }

  Future<bool?> onBackButton(BuildContext context) async => showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
            title: Text("Do you want to exit?"),
            actions: <Widget>[
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () => Navigator.pop(context, false),
                  child: Text("No")),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green, // background
                    onPrimary: Colors.white, // foreground
                  ),
                  onPressed: () => Navigator.pop(context, true),
                  child: Text("Yes")),
            ],
          ));

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        print("back button press");
        final backPopup = await onBackButton(context);

        return backPopup ?? false;
      },
      child: SafeArea(
          child: Scaffold(
        body: PageView(
          controller: _pageController,
          children: _screens,
          onPageChanged: _onPageChange,
          physics: NeverScrollableScrollPhysics(),
        ),
        bottomNavigationBar: BottomNavigationBar(
          onTap: _onItemTapped,
          items: const <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Icon(Icons.check_box),
              label: 'To-Do',
            ),
            BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month), label: 'Calendar'),
            BottomNavigationBarItem(
                icon: Icon(Icons.settings), label: 'Setting'),
          ],
          currentIndex: _selectedIndex,
          selectedItemColor: Colors.green,
        ),
      )),
    );
  }
}
