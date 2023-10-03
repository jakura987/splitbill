import 'package:flutter/material.dart';
import 'package:spiltbill/main_module/settings_page.dart';

import 'main_module/bill_page.dart';
import 'main_module/group_page.dart';
import 'main_module/home_page.dart';
import 'main_module/me_page.dart';
import 'main_module/add_page.dart';
import 'constants/palette.dart';


class NavigatePage extends StatefulWidget {
  @override
  _NavigatePageState createState() => _NavigatePageState();
}

// ... 其他不变的部分

class _NavigatePageState extends State<NavigatePage> {
  int _currentIndex = 0; // 当前选中的页面索引

  final List<Widget> _pages = [
    HomePage(),
    GroupPage(),
    AddPage(),
    BillPage(),
    MePage(),
    SettingsPage()
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
          boxShadow: [BoxShadow(color: Colors.black12, spreadRadius: 0, blurRadius: 1)],
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          child: BottomNavigationBar(
            elevation: 0,
            backgroundColor: Colors.white,
            items: const <BottomNavigationBarItem>[
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.group),
                label: 'Group',
              ),
              BottomNavigationBarItem(
                icon: Padding(
                  padding: EdgeInsets.symmetric(vertical: 10.0),
                  child: CircleAvatar(
                    radius: 20,
                    backgroundColor: Palette.primaryColor,
                    child: Icon(Icons.add, color: Colors.white, size: 30),
                  ),
                ),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.receipt),
                label: 'Bill',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Me',
              ),
            ],
            currentIndex: _currentIndex,
            selectedItemColor: Palette.primaryColor,
            unselectedItemColor: Colors.grey,
            onTap: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            type: BottomNavigationBarType.fixed,
          ),
        ),
      ),
    );
  }
}

// ... 其他不变的部分
