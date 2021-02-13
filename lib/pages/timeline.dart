import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:social_connect/widgets/header.dart';
import 'package:social_connect/widgets/progress.dart';

final usersRef = FirebaseFirestore.instance.collection('users');

class Timeline extends StatefulWidget {
  @override
  _TimelineState createState() => _TimelineState();
}

class _TimelineState extends State<Timeline> {
  @override
  void initState() {
    getUser();
    super.initState();
  }

  // get all data
  // void getUser() {
  //   usersRef.get().then((QuerySnapshot snapshot) {
  //     snapshot.docs.forEach((DocumentSnapshot doc) {
  //       print(doc.data());
  //       print(doc.exists);
  //       print(doc.id);
  //     });
  //   });
  // }

  void getUser() async {
    final QuerySnapshot snapshot = await usersRef
        // .where('postCount', isGreaterThan: 3)
        // .where('username', isEqualTo: 'Rishu')
        .limit(1)
        //.orderBy('postsCount', descending: true)
        .get();
    snapshot.docs.forEach((DocumentSnapshot doc) {
      print(doc.data());
      print(doc.exists);
      print(doc.id);
    });
  }

  // gettting specific data according to id
  // getUserById() {
  //   String id = 'H9oNTLEVob5HKLPfy954';
  //   usersRef.doc(id).get().then((DocumentSnapshot doc) {
  //     print(doc.data());
  //     print(doc.exists);
  //     print(doc.id);
  //   });
  // }

  getUserData() async {
    String id = 'H9oNTLEVob5HKLPfy954';
    final DocumentSnapshot doc = await usersRef.doc(id).get();
    print(doc.data());
    print(doc.exists);
    print(doc.id);
  }

  @override
  Widget build(context) {
    return Scaffold(
        appBar: header(context: context, title: 'TimeLine'),
        body: Text('Time Liner'));
  }
}
