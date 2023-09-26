import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_page.dart';
// when user logins successfully, trigger this page
class WelcomePage extends StatelessWidget {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  Future<String> getUserName() async {
    final user = _auth.currentUser;
    if (user == null) return 'Welcome'; // 如果没有用户登录，返回默认欢迎信息

    final userDoc = await _firestore
        .collection('users')
        .where('email', isEqualTo: user.email) // 使用 email 查询用户文档
        .limit(1)
        .get();

    if (userDoc.size == 0) return 'Welcome'; // 如果没有找到用户文档，返回默认欢迎信息

    final userName = userDoc.docs.first['name'];
    return 'Welcome $userName'; // 返回带有用户名的欢迎信息
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () async{
            await _auth.signOut();//登出用户
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => LoginPage()));//跳转到login页面
          },
        ),
        title: Text('Welcome Page'),
      ),

      body: Center(
        child: FutureBuilder<String>(
          future: getUserName(), // 调用函数获取用户名
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator(); // 加载中显示加载指示器
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}'); // 出错时显示错误信息
            }
            return Text(snapshot.data ?? 'Welcome', style: TextStyle(fontSize: 24));
          },
        ),
      ),
    );
  }
}

