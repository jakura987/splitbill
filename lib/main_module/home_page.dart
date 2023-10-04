import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import '../login_page.dart';
import '../models/user_model.dart';
import '../auth_service.dart';
import 'add_page.dart';
import 'bill_page.dart';
import '../constants/palette.dart';

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
      final userModel = Provider.of<UserModel>(context, listen: false);
      userModel.fetchUser();
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    UserModel userModel = Provider.of<UserModel>(context);

    return Scaffold(
      backgroundColor: Palette.backgroundColor,
      appBar: AppBar(
        title: Text('Hello, ${userModel.userName}',
            style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        centerTitle: true,
        elevation: 1.0,
        actions: [
          CircleAvatar(
            backgroundImage: AssetImage('path_to_user_image.png'),
          ),
          SizedBox(width: 10), // 在头像的右侧添加一些空间
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: Container(
                height: MediaQuery.of(context).size.height * 0.25,
                // 25% of screen height
                width: MediaQuery.of(context).size.width * 0.9,
                // 90% of screen width
                margin: const EdgeInsets.symmetric(vertical: 20.0),
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  color: Palette.primaryColor,
                  borderRadius: BorderRadius.circular(30.0),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Need to split？",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 40),
                    // Increased spacing between the text and the button
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        // Button color
                        foregroundColor: Palette.primaryColor,
                        // Text color
                        padding: EdgeInsets.symmetric(
                            vertical: 20.0, horizontal: 30.0),
                        // Increase text padding inside the button
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20.0),
                        ),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => AddPage()),
                        );
                      },
                      child: Text(
                        "Create new bill",
                        style: TextStyle(
                            fontSize: 24, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          // Bills Display Title
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text("Recent bills",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold)),
                InkWell(
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => BillPage()));
                  },
                  child: Text("See all",
                      style: TextStyle(
                          color: Palette.primaryColor,
                          fontSize: 16,
                          fontWeight: FontWeight.bold)),
                ),
              ],
            ),
          ), // Bills Display

          // Bills Display
          Expanded(
            child: StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('bills').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text("Something went wrong!"));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                final bills = snapshot.data?.docs ?? [];
                return ListView.builder(
                  itemCount: bills.length,
                  itemBuilder: (context, index) {
                    final bill = bills[index];
                    final billName = bill['billName'] ?? "No name";
                    final billPrice = bill['billPrice'] ?? "0.0";

                    // Timestamp processing
                    final Timestamp timestamp = bill['billDate'];
                    final DateTime billDate = timestamp.toDate();
                    final formattedDate =
                        "${billDate.year}-${billDate.month}-${billDate.day}";

                    final peopleNumber =
                        bill['peopleNumber'] ?? "Unknown Count";

                    return Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0),
                      ),
                      margin: EdgeInsets.symmetric(
                          vertical: 10.0, horizontal: 20.0),
                      child: ListTile(
                        contentPadding: EdgeInsets.symmetric(
                            vertical: 5.0, horizontal: 20.0),
                        leading: Container(
                          width: 40.0,
                          height: 40.0,
                          decoration: BoxDecoration(
                            color: Palette.primaryColor,
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Icon(Icons.receipt, color: Colors.white),
                        ),
                        title: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(billName,
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold)),
                            Text("\$ $billPrice",
                                style: TextStyle(
                                    color: Colors.black, fontSize: 16,fontWeight: FontWeight.bold))
                          ],
                        ),
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(formattedDate,
                                style: TextStyle(
                                    color: Palette.secondaryColor,
                                    fontWeight: FontWeight.bold)),
                            Text("$peopleNumber people",
                                style: TextStyle(
                                    color: Palette.secondaryColor,
                                    fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
