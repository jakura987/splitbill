import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../login_page.dart';
import '../user_model.dart';
import '../auth_service.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isInit = false;
      // 调用 UserModel 的 fetchUser 方法
      final userModel = Provider.of<UserModel>(context, listen: false);
      userModel.fetchUser();
    }
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    // 获取UserModel的实例
    UserModel userModel = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async {
            final authService = Provider.of<AuthService>(context, listen: false);
            await authService.signOut();
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage())); //跳转到login页面
          },
        ),
        title: Text('Home Page'),
      ),
      body: Center(
        child: Text(userModel.userName, style: TextStyle(fontSize: 24)),
      ),
    );
  }

}
