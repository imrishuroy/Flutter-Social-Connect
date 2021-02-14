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
  // List<dynamic> users = [];

  @override
  void initState() {
    // getUser();
    createUser();
    //updateUser();
    //deleteUser();
    super.initState();
  }
  ////################### CRUD OPERATION ON FIREBASE #################////////

// add data by creating its own unique id
  // createUser() async{
  //  await usersRef.add({
  //     'username':'Ram',
  //     'postsCount':5,
  //     'isAdmin':true,
  //   });
  // }
  // create new user
  createUser() {
    usersRef.doc('kcbcbjkbkbk').set({
      'username': 'New User',
      'postsCount': 1,
      'isAdmin': true,
    });
  }

// update old data
  updateUser() async {
    final doc = await usersRef.doc('kcbcbbvjkbkbk').get();
    if (doc.exists) {
      doc.reference.update({
        'username': 'Shree Ram',
        'postsCount': 5,
        'isAdmin': true,
      });
    }
    // usersRef.doc('kcbcbbvj').update({
    //   'username': 'Shree Ram',
    //   'postsCount': 5,
    //   'isAdmin': true,
    // });
  }

  deleteUser() async {
    final doc = await usersRef.doc('kcbcbjkbkbk').get();
    if (doc.exists) {
      doc.reference.delete();
    }
    // usersRef.doc('H9oNTLEVob5HKLPfy954').delete();
  }

  /*

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
    final QuerySnapshot snapshot = await usersRef.get();
    // .where('postCount', isGreaterThan: 3)
    // .where('username', isEqualTo: 'Rishu')
    // .limit(1)
    //.orderBy('postsCount', descending: true)
    // .get();
    setState(() {
      users = snapshot.docs;
    });
    // snapshot.docs.forEach((DocumentSnapshot doc) {
    //   print(doc.data());
    //   print(doc.exists);
    //   print(doc.id);
    // });
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
  */

  @override
  Widget build(context) {
    return Scaffold(
      appBar: header(context: context, title: 'TimeLine'),
      // body: FutureBuilder<QuerySnapshot>(
      body: StreamBuilder<QuerySnapshot>(
        // future: usersRef.get(),
        stream: usersRef.snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return circularProgress();
          }
          final List<Text> childern =
              snapshot.data.docs.map((doc) => Text(doc['username'])).toList();
          return Container(
            child: ListView(
              children: childern,
            ),
          );
        },
      ),
    );
  }
}

// Container(
//         child: ListView(
//           children: users.map((user) => Text(user['username'])).toList(),
//         ),
//       ),
