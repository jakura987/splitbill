import 'package:flutter/material.dart';

const kPrimaryColor = Color(0xff65B8A6);
const kSecondaryColor = Color(0xffDBDBDB);
final kFillColor = Colors.grey[200];

const kAppName = 'SplitBill';
const kUsernameHint = 'Username';
const kPasswordHint = 'Password';
const kLoginButtonText = 'Login';
const kRegisterButtonText = 'Register';

void main() {
  runApp(MyApp());
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
      home: LoginRegisterPage(),
    );
  }
}

class LoginRegisterPage extends StatelessWidget {
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
        child: Center(
          child: LoginRegisterForm(),
        ),
      ),
    );
  }
}

class LoginRegisterForm extends StatelessWidget {
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
          CustomTextField(hint: kUsernameHint),
          SizedBox(height: 16),
          CustomTextField(hint: kPasswordHint, isObscured: true),
          SizedBox(height: 16),
          CustomElevatedButton(onPressed: () {}, text: kLoginButtonText),
          CustomTextButton(onPressed: () {}, text: kRegisterButtonText),
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

class CustomTextField extends StatelessWidget {
  final String hint;
  final bool isObscured;

  CustomTextField({required this.hint, this.isObscured = false});

  @override
  Widget build(BuildContext context) {
    return TextField(
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

class CustomElevatedButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  CustomElevatedButton({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}

class CustomTextButton extends StatelessWidget {
  final VoidCallback onPressed;
  final String text;

  CustomTextButton({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
