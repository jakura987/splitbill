import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'create_bill.dart';

class PlusPage extends StatefulWidget {
  @override
  _ChooseGroupState createState() => _ChooseGroupState();
}

class _ChooseGroupState extends State<PlusPage> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<String> selectedGroups = [];
  bool allGroupsSelected = false;  // 新增

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Choose your group"),
      ),
      body: Column(
        children: [
          Expanded(
            child: StreamBuilder(
              stream: _firestore.collection('groups').snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) return CircularProgressIndicator();
                List<String> allGroupNames = snapshot.data!.docs.map((doc) => doc['groupName'] as String).toList();
                return ListView(
                  children: [
                    CheckboxListTile(  // 新增
                      title: Text("All Groups", style: TextStyle(fontSize: 24)),
                      value: allGroupsSelected,
                      onChanged: (bool? value) {
                        setState(() {
                          allGroupsSelected = value!;
                          if (allGroupsSelected) {
                            selectedGroups = List.from(allGroupNames);
                          } else {
                            selectedGroups.clear();
                          }
                        });
                      },
                    ),
                    ...List.generate(snapshot.data!.docs.length, (index) {
                      final group = snapshot.data!.docs[index];
                      final groupName = group['groupName'] as String; // 获取groupName字段
                      return CheckboxListTile(
                        title: Text(groupName, style: TextStyle(fontSize: 24)),
                        value: selectedGroups.contains(groupName),
                        onChanged: (bool? value) {
                          setState(() {
                            if (value == true) {
                              selectedGroups.add(groupName);
                              if (selectedGroups.length == allGroupNames.length) {
                                allGroupsSelected = true;
                              }
                            } else {
                              selectedGroups.remove(groupName);
                              allGroupsSelected = false;
                            }
                          });
                        },
                      );
                    }),
                  ],
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

