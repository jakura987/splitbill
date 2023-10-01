import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_bill.dart';

class AddPage extends StatefulWidget {
  @override
  _ChooseGroupState createState() => _ChooseGroupState();
}


class _ChooseGroupState extends State<AddPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> selectedGroups = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose your group",),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('groups').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                return ListView.builder(
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final group = snapshot.data!.docs[index];
                    final groupName = group['groupName'] as String; // 获取groupName字段
                    return CheckboxListTile(
                      title: Text(groupName, style: TextStyle(fontSize: 24)),
                      value: selectedGroups.contains(groupName),
                      onChanged: (bool? value) {
                        setState(() {
                          if (value == true) {
                            selectedGroups.add(groupName);
                          } else {
                            selectedGroups.remove(groupName);
                          }
                        });
                      },
                    );
                  },
                );
              },
            ),
          ),

          ElevatedButton(
            onPressed: selectedGroups.isNotEmpty
                ? () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => CreateBill(selectedGroups: selectedGroups),
                ),
              );
            }
                : null,
            child: Text('Continue', style: TextStyle(fontSize: 24)),
          ),
        ],
      ),
    );
  }
}
