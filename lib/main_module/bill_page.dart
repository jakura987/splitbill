import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:provider/provider.dart';
import '../user_model.dart';

class Bill {
  final String documentId;  // <-- Add this
  final String name;
  final double price;
  final DateTime dateTime;
  final int numberOfPeople;
  final String billDescription;
  final double AAPP;
  final List<PersonStatus> peopleStatus;

  Bill({
    required this.documentId,  // <-- Add this
    required this.name,
    required this.price,
    required this.dateTime,
    required this.numberOfPeople,
    required this.billDescription,
    required this.AAPP,
    required this.peopleStatus,
  });
}


class BillPage extends StatefulWidget {
  @override
  _ShowBillState createState() => _ShowBillState();
}

class PersonStatus {
  final String name;
  final bool status;

  PersonStatus({required this.name, required this.status});
}

class _ShowBillState extends State<BillPage>  with SingleTickerProviderStateMixin {

  TabController? _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController?.dispose();
    super.dispose();
  }


  bool _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      _isInit = false;
      // 调用 UserModel 的 fetchUser 方法
      final userModel = Provider.of<UserModel>(context, listen: false);
      userModel.fetchUser();
    }
    super.didChangeDependencies();
  }


  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final CollectionReference bills = FirebaseFirestore.instance.collection('bills');

  List<PersonStatus> parsePersonStatus(List<dynamic> peopleStatusList) {
    return peopleStatusList.map((personStatusMap) {
      return PersonStatus(
        name: personStatusMap['name'],
        status: personStatusMap['status'],
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    // 获取UserModel的实例
    UserModel userModel = Provider.of<UserModel>(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Show Bills'),
        bottom: TabBar(  // Add this TabBar
          controller: _tabController,
          tabs: [
            Tab(text: "All Bills"),
            Tab(text: "Finished Bills"),
            Tab(text: "Unfinished Bills"),
          ],
        ),
      ),
      body: TabBarView(  // And this TabBarView
        controller: _tabController,
        children: [
          _buildBillList(userModel, null),  // All bills
          _buildBillList(userModel, true),  // Finished bills
          _buildBillList(userModel, false),  // Unfinished bills
        ],
      ),
    );

      // body: StreamBuilder<QuerySnapshot>(
      //   stream: _firestore.collection('bills').where('peopleName', arrayContains: userModel.userName).snapshots(),
      //   builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
      //     if (snapshot.hasError) {
      //       return Center(child: Text('Something went wrong'));
      //     }
      //
      //     if (snapshot.connectionState == ConnectionState.waiting) {
      //       return Center(child: CircularProgressIndicator());
      //     }
      //
      //     return ListView(
      //       children: snapshot.data!.docs.map((DocumentSnapshot document) {
      //         Map<String, dynamic> data = document.data() as Map<String, dynamic>;
      //         return BillBox(
      //           bill: Bill(
      //             documentId: document.id,  // <-- Add this
      //             name: data['billName'] ?? "Unknown",
      //             price: data['billPrice']?.toDouble() ?? 0.0,
      //             dateTime: (data['billDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      //             numberOfPeople: data['peopleNumber']?.toInt() ?? 0,
      //             billDescription: data['billDescription'] ?? "Description not provided",
      //             AAPP: data['AAPP']?.toDouble() ?? 0.0,
      //             peopleStatus: data['peopleStatus'] != null ? parsePersonStatus(data['peopleStatus']) : [],
      //           ),
      //         );
      //       }).toList(),
      //     );
      //   },
      // ),
  }
  Widget _buildBillList(UserModel userModel, bool? isFinished) {
    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('bills').where(
        'peopleName',
        arrayContains: userModel.userName,
      ).snapshots(),
      builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
        if (snapshot.hasError) {
          return Center(child: Text('Something went wrong'));
        }
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        List<BillBox> bills = snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          List<PersonStatus> personStatuses = parsePersonStatus(data['peopleStatus'] ?? []);
          if (isFinished == null || personStatuses.any((status) => status.name == userModel.userName && status.status == isFinished)) {
            return BillBox(
                          bill: Bill(
                            documentId: document.id,  // <-- Add this
                            name: data['billName'] ?? "Unknown",
                            price: data['billPrice']?.toDouble() ?? 0.0,
                            dateTime: (data['billDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
                            numberOfPeople: data['peopleNumber']?.toInt() ?? 0,
                            billDescription: data['billDescription'] ?? "Description not provided",
                            AAPP: data['AAPP']?.toDouble() ?? 0.0,
                            peopleStatus: data['peopleStatus'] != null ? parsePersonStatus(data['peopleStatus']) : [],
                          ),
                        );
          } else {
            return null;
          }
        }).where((billBox) => billBox != null).toList().cast<BillBox>();

        return ListView(children: bills);
      },
    );
  }
}


class BillBox extends StatelessWidget {
  final Bill bill;

  BillBox({required this.bill});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 8.0),
      child: InkWell(
        onTap: () => _showBillDetails(context, bill),
        child: Container(
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.5),
                spreadRadius: 1,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Row(
            children: [
              // ClipRRect(
              //   borderRadius: BorderRadius.circular(8.0),
              //   child: Image.asset(bill.image, width: 80, height: 80, fit: BoxFit.cover),
              // ),
              SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // 使用这个属性使子元素右对齐
                      children: [
                        Row(
                          children: [
                            Icon(Icons.label, color: Colors.blue),
                            SizedBox(width: 4),
                            Text(bill.name, style: TextStyle(
                                fontSize: 24, fontWeight: FontWeight.bold)),
                          ],
                        ),
                        Text('\$${bill.price.toStringAsFixed(2)}',
                            style: TextStyle(fontSize: 20, color: Colors
                                .green)),
                      ],
                    ),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      // 使用这个属性使子元素右对齐
                      children: [
                        Row(
                          children: [
                            Icon(Icons.date_range, color: Colors.orange),
                            SizedBox(width: 4),
                            Text('${bill.dateTime.toLocal()}'.split(' ')[0],
                                style: TextStyle(fontSize: 20)),
                          ],
                        ),
                        Row(
                          children: [
                            Icon(Icons.people, color: Colors.purple),
                            SizedBox(width: 4),
                            Text('${bill.numberOfPeople} people',
                                style: TextStyle(fontSize: 20)),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  _showBillDetails(BuildContext context, Bill bill) {
    UserModel userModel = Provider.of<UserModel>(
        context, listen: false); // 获取当前用户

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Bill Details'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Bill Name: ${bill.name}', style: TextStyle(fontSize: 20)),
                Text('Total Bill Amount: \$${bill.price.toStringAsFixed(2)}',
                    style: TextStyle(fontSize: 20)),
                Text('Description: ${bill.billDescription}',
                    style: TextStyle(fontSize: 20)),
                Text('Average Amount Per Person: \$${bill.AAPP.toStringAsFixed(
                    2)}', style: TextStyle(fontSize: 20)),
                // Padding(
                //   padding: const EdgeInsets.symmetric(vertical: 10.0),
                //   child: Text('People Status', style: TextStyle(fontWeight: FontWeight.bold)),
                // ),
                ExpansionTile(
                  title: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10.0),
                    child: Text(
                        'People Status', style: TextStyle(fontSize: 20)),
                  ),
                  children: bill.peopleStatus.map((personStatus) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 4.0),
                      // 为每个状态添加少量的底部间距
                      child: Text('${personStatus.name}: ${personStatus.status
                          ? "done"
                          : "undone"}', style: TextStyle(fontSize: 20)),
                    );
                  }).toList(),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Settled'),
              onPressed: () async {
                // 获取当前用户
                UserModel userModel = Provider.of<UserModel>(context, listen: false);

                // 更新Firestore中的数据
                DocumentReference billRef = FirebaseFirestore.instance.collection('bills').doc(bill.documentId);  // Use bill.documentId here
                List<PersonStatus> updatedStatus = [];

                for (PersonStatus status in bill.peopleStatus) {
                  if (status.name == userModel.userName) {
                    updatedStatus.add(PersonStatus(name: status.name, status: true));
                  } else {
                    updatedStatus.add(status);
                  }
                }

                await billRef.update({
                  'peopleStatus': updatedStatus.map((status) => {
                    'name': status.name,
                    'status': status.status
                  }).toList()
                });

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}