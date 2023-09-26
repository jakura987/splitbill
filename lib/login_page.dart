import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'welcome_page.dart';

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



  @override
  Widget build(BuildContext context) {
    return Container(
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
          RegisterButton(onPressed: () {}, text: kRegisterButtonText),
        ],
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
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
