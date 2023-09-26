import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'firebase_options.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保 Flutter 绑定初始化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // 初始化 Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      theme: ThemeData(
        primaryColor: kPrimaryColor, // 常量 kPrimaryColor 也已经移动到 login_page.dart，可以在这里直接定义颜色值
        colorScheme: ThemeData().colorScheme.copyWith(secondary: kSecondaryColor), // 常量 kSecondaryColor 也已经移动到 login_page.dart，可以在这里直接定义颜色值
        buttonTheme: ButtonThemeData(
          buttonColor: kPrimaryColor, // 常量 kPrimaryColor 也已经移动到 login_page.dart，可以在这里直接定义颜色值
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: LoginPage(), // 使用刚刚在 login_page.dart 中定义的 LoginRegisterPage
    );
  }
}
