import 'package:flutter/material.dart';

import 'main_module/bill_page.dart';
import 'main_module/group_page.dart';
import 'main_module/home_page.dart';
import 'main_module/me_page.dart';
import 'main_module/add_page.dart';


class NavigatePage extends StatefulWidget {
  @override
  _NavigatePageState createState() => _NavigatePageState();
}

class _NavigatePageState extends State<NavigatePage> {
  int _currentIndex = 0; // 当前选中的页面索引

  final List<Widget> _pages = [
    HomePage(),
    GroupPage(),
    AddPage(),
    BillPage(),
    MePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: BottomNavigationBar(
        unselectedItemColor: Colors.grey, // 未选中项的颜色
        selectedItemColor: Colors.black, // 选中项的颜色
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.group), label: 'Group'),
          BottomNavigationBarItem(icon: Icon(Icons.add), label: '+'),
          BottomNavigationBarItem(icon: Icon(Icons.receipt), label: 'Bill'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Me'),
        ],
      ),
    );
  }
}