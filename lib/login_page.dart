import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:spiltbill/dashed_line.dart';
import 'package:spiltbill/register_page.dart';
import 'welcome_page.dart';

//TODO 将颜色背景之类的写成常量放一个文件
const kPrimaryColor = Color(0xff65B8A6);
const kSecondaryColor = Color(0xffDBDBDB);
final kFillColor = Colors.grey[200];
const kAppName = 'SplitBill';
const kUsernameHint = 'Username';
const kPasswordHint = 'Password';
const kLoginButtonText = 'Login';
const kRegisterButtonText = 'Register';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kPrimaryColor, kSecondaryColor],
          ),
        ),
        child: Center(child: LoginForm()),
      ),
    );
  }
}

class LoginForm extends StatefulWidget {
  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  //非第三放登录方法
  Future<void> _login() async {
    final String email = _usernameController.text;
    final String password = _passwordController.text;

    try {
      final UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => WelcomePage()),
      );
    } on FirebaseAuthException catch (e) {
      print('FirebaseAuthException code: ${e.code}'); // print error code
      String message;
      switch (e.code) {
        case 'invalid-email':
          message = 'Bob found your email address format is incorrect';
          break;
        case 'INVALID_LOGIN_CREDENTIALS':
          message = 'Bob suggests checking if your email address and password are correct';
          break;
        default:
          message = 'login fail：${e.message}';
          break;
      }
      final snackBar = SnackBar(content: Text(message)); // 创建SnackBar
      ScaffoldMessenger.of(context).showSnackBar(snackBar); // 显示SnackBar
    }
  }

  //跳转register页面
  void _navigateToRegisterPage() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => RegisterPage()),
    );
  }


  // void _googleSignIn() async { //第三方google登录方法
  //   try {
  //     final GoogleSignInAccount? googleSignInAccount = await GoogleSignIn().signIn();
  //     if (googleSignInAccount != null) {
  //       final GoogleSignInAuthentication googleSignInAuthentication =
  //       await googleSignInAccount.authentication;
  //       final AuthCredential credential = GoogleAuthProvider.credential(
  //         accessToken: googleSignInAuthentication.accessToken,
  //         idToken: googleSignInAuthentication.idToken,
  //       );
  //
  //       await FirebaseAuth.instance.signInWithCredential(credential);
  //
  //       // Navigate to GooglePage after a successful login
  //       Navigator.pushReplacement(
  //         context,
  //         MaterialPageRoute(builder: (context) => WelcomePage()),
  //       );
  //     }
  //   } catch (error) {
  //     // Handle error
  //     print('Google Sign In failed: $error');
  //   }
  // }


  @override
  Widget build(BuildContext context) {
    return Center(
      child: SingleChildScrollView( // 使用SingleChildScrollView来允许滚动
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, // 居中对齐
          children: [
            Container( //第一个容器(登录注册)
              width: 300,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  AppName(),
                  SizedBox(height: 16),
                  CustomTextField(controller: _usernameController, hint: kUsernameHint),
                  SizedBox(height: 16),
                  CustomTextField(controller: _passwordController, hint: kPasswordHint, isObscured: true),
                  SizedBox(height: 16),
                  LoginButton(onPressed: _login, text: kLoginButtonText),
                  RegisterButton(onPressed: _navigateToRegisterPage, text: kRegisterButtonText),

                ],
              ),
            ),
            DashedLine(width: 300),
        Container( //TODO 第二个容器,目前只显示了hello world, 换成下面那个google第三方登录图标
          width: 300,
          padding: EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
          ),
        child: Text("在这边实现第三方登录(图标在assets包里),我是笨比我不会"),
      ),

            // Container( //第二个容器
            //   width: 300,
            //   padding: EdgeInsets.all(16),
            //   decoration: BoxDecoration(
            //     color: Colors.white,
            //     borderRadius: BorderRadius.circular(8),
            //   ),
            //   child: IconButton(
            //     icon: Image.asset('assets/images/btn_google.png'), // 请替换为您Google图标的路径
            //     onPressed: _googleSignIn,
            //   ),
            // )
          ],
        ),
      ),
    );
  }

}

class AppName extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Text(
      kAppName,
      style: TextStyle(
        fontSize: 24,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

//TODO: register_page也有一个类似的方法,垄余
// CustomTextField is a custom text input component
class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isObscured;

  CustomTextField({required this.controller, required this.hint, this.isObscured = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        filled: true,
        fillColor: kFillColor,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: BorderSide.none,
        ),
      ),
      obscureText: isObscured,
    );
  }
}

// LoginButton is a custom ElevatedButton
class LoginButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  LoginButton({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

// RegisterButton is a custom TextButton
class RegisterButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  RegisterButton({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed, // 在这里使用传入的 onPressed 函数
      child: Text(text),
    );
  }
}


