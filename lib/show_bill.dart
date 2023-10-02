import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Bill {
  // final String image;
  final String name;
  final double price;
  final DateTime dateTime;
  final int numberOfPeople;

  Bill({ required this.name, required this.price, required this.dateTime, required this.numberOfPeople});
}

class ShowBill extends StatefulWidget {
  @override
  _ShowBillState createState() => _ShowBillState();
}

class _ShowBillState extends State<ShowBill> {
  final CollectionReference bills = FirebaseFirestore.instance.collection('bills');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Show Bills')),
      body: StreamBuilder<QuerySnapshot>(
        stream: bills.snapshots(),
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Something went wrong'));
          }

          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          return ListView(
            children: snapshot.data!.docs.map((DocumentSnapshot document) {
              Map<String, dynamic> data = document.data() as Map<String, dynamic>;
              return BillBox(
                bill: Bill(
                  // image: data['billImg'],
                  name: data['billName'],
                  price: data['billPrice'].toDouble(),
                  dateTime: (data['billDate'] as Timestamp).toDate(),
                  numberOfPeople: data['peopleNumber'].toInt(),
                ),
              );
            }).toList(),
          );
        },
      ),
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
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,  // 使用这个属性使子元素右对齐
                    children: [
                      Row(
                        children: [
                          Icon(Icons.label, color: Colors.blue),
                          SizedBox(width: 4),
                          Text(bill.name, style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                        ],
                      ),
                      Text('\$${bill.price.toStringAsFixed(2)}', style: TextStyle(fontSize: 20, color: Colors.green)),
                    ],
                  ),
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,  // 使用这个属性使子元素右对齐
                    children: [
                      Row(
                        children: [
                          Icon(Icons.date_range, color: Colors.orange),
                          SizedBox(width: 4),
                          Text('${bill.dateTime.toLocal()}'.split(' ')[0], style: TextStyle(fontSize: 20)),
                        ],
                      ),
                      Row(
                        children: [
                          Icon(Icons.people, color: Colors.purple),
                          SizedBox(width: 4),
                          Text('${bill.numberOfPeople} people', style: TextStyle(fontSize: 20)),
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
    );
  }
}


