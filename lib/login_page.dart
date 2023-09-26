import 'package:flutter/material.dart';
import 'welcome_page.dart';

// Define global constants, colors and text
const kPrimaryColor = Color(0xff65B8A6);
const kSecondaryColor = Color(0xffDBDBDB);
final kFillColor = Colors.grey[200];
const kAppName = 'SplitBill';
const kUsernameHint = 'Username';
const kPasswordHint = 'Password';
const kLoginButtonText = 'Login';
const kRegisterButtonText = 'Register';

// LoginPage as the entry point for the login interface
class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Use Scaffold to build the basic visual structure
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [kPrimaryColor, kSecondaryColor],
          ),
        ),
        // LoginForm (main part of the login interface)
        child: Center(child: LoginForm()),
      ),
    );
  }
}

// LoginForm includes all the input fields and buttons
class LoginForm extends StatelessWidget {
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
        // build all the subcomponents of the loginForm
        children: [
          AppName(),
          SizedBox(height: 16),
          CustomTextField(hint: kUsernameHint),
          SizedBox(height: 16),
          CustomTextField(hint: kPasswordHint, isObscured: true),
          SizedBox(height: 16),
          LoginButton(onPressed: () {
            // Navigate to the WelcomePage when pressing the button
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => WelcomePage()),
            );
          }, text: kLoginButtonText),
          RegisterButton(onPressed: () {}, text: kRegisterButtonText),
        ],
      ),
    );
  }
}

// The AppName component displays the name of the application which is 'SplitBill'
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
  final String hint; // Input prompt text
  final bool isObscured; // Whether the text should be obscured for password fields

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

// LoginButton is a custom ElevatedButton
class LoginButton  extends StatelessWidget {
  final VoidCallback onPressed; // Callback triggered when the button is pressed
  final String text; // Button text

  LoginButton ({required this.onPressed, required this.text});

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
  final VoidCallback onPressed; // Callback triggered when the button is presses
  final String text; // Button text

  RegisterButton({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: Text(text),
    );
  }
}
