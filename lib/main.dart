import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:spiltbill/user_model.dart';
import 'auth_service.dart';
import 'firebase_options.dart';
import 'login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // 确保 Flutter 绑定初始化
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // 初始化 Firebase
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => UserModel(),
        ),
        Provider(
          create: (context) => AuthService(),
        ),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: kAppName,
      theme: ThemeData(
        primaryColor: kPrimaryColor,
        colorScheme: ThemeData().colorScheme.copyWith(secondary: kSecondaryColor),
        buttonTheme: ButtonThemeData(
          buttonColor: kPrimaryColor,
          textTheme: ButtonTextTheme.primary,
        ),
      ),
      home: LoginPage(),
    );
  }
}
