import 'package:flutter/material.dart';
import 'login_page.dart'; //

// when user logins successfully, trigger this page
class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => LoginPage()),
          ),
        ),
      ),
      body: Center(
        child: Text('Welcome', style: TextStyle(fontSize: 24)),
      ),
    );
  }
}
